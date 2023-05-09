//
//  BookmarksViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 05.05.2023.
//

import Foundation

extension BookmarksView {

    /// A `ViewController` that interacts with ``PersistenceManager`` for listing
    /// all bookmarked users and deleting individual bookmarks.
    @MainActor class ViewModel: ObservableObject {

        // MARK: - @Published variables

        /// All bookmarked users retrieved by ``PersistenceManager``.
        @Published var bookmarks: [Follower] = []

        /// A `path` array for `NavigationStack` of ``BookmarksView``.
        @Published var selectedBookmarks: [Follower] = []

        /// A trigger for showing ``GFEmptyStateView`` in ``BookmarksView`` if
        /// list of ``bookmarks`` is empty.
        @Published var showEmptyState = false

        /// A trigger for displaying ``GFAlertView`` by ``BookmarksView`` with
        /// ``GFPersistenceError`` description.
        @Published var showBookmarksRetrieveError = false

        /// Description of ``GFPersistenceError`` to pass as a message into ``GFAlertView``.
        @Published var bookmarksErrorMessage = "problem with getting bookmarks."

        // MARK: - Methods

        /// Calls ``PersistenceManager``.``PersistenceManager/retrieveBookmarks(completion:)``
        /// method.
        ///
        /// If retrieve request fails - this method triggers presentation of a ``GFAlertView``
        /// with ``GFPersistenceError`` description in ``BookmarksView`` by
        /// activating ``showBookmarksRetrieveError``.
        ///
        /// If request returns an empty array - this method triggers display of an empty state view
        /// in ``BookmarksView`` by activating ``showEmptyState``.
        ///
        /// If request is successful - this method assigns ``bookmarks``, updating `List`
        /// in ``BookmarksView``.
        func getBookmarks() {
            PersistenceManager.retrieveBookmarks { [weak self] result in

                guard let self else { return }

                switch result {
                case .success(let bookmarks):
                    if bookmarks.isEmpty {
                        DispatchQueue.main.async {
                            self.showEmptyState = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.bookmarks = bookmarks
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.bookmarksErrorMessage = error.rawValue
                        self.showBookmarksRetrieveError = true
                    }
                }
            }
        }

        /// Retrieves the bookmark selected for deletion from ``bookmarks`` array and
        /// calls ``PersistenceManager``.``PersistenceManager/updateWith(_:actionType:completion:)``
        /// method with ``PersistenceActionType/remove`` type.
        ///
        /// If the call to ``PersistenceManager`` fails - this method triggers presentation of
        /// a ``GFAlertView`` with ``GFPersistenceError`` description in ``BookmarksView``
        /// by activating ``showBookmarksRetrieveError``.
        ///
        /// If ``bookmarks`` array is empty after the call executes - this method triggers display of an
        /// empty state view in ``BookmarksView`` by activating ``showEmptyState``.
        /// - Parameter offsets: Offsets at which the bookmarks must be deleted.
        func deleteBookmarks(atOffsets offsets: IndexSet) {
            guard let index = offsets.first else { return }
            let bookmark = bookmarks[index]

            PersistenceManager.updateWith(bookmark, actionType: .remove) { [weak self] error in

                guard let self else { return }

                if let error {
                    DispatchQueue.main.async {
                        self.bookmarksErrorMessage = error.rawValue
                        self.showBookmarksRetrieveError = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.bookmarks.remove(at: index)
                        if self.bookmarks.isEmpty {
                            self.showEmptyState = true
                        }
                    }
                }
            }
        }
    }
}
