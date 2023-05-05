//
//  BookmarksViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 05.05.2023.
//

import Foundation

extension BookmarksView {
    @MainActor class ViewModel: ObservableObject {

        @Published var bookmarks: [Follower] = []
        @Published var selectedBookmarks: [Follower] = []

        @Published var showEmptyState = false
        @Published var showBookmarksRetrieveError = false
        @Published var bookmarksErrorMessage = "problem with getting bookmarks."

        init() {
            getBookmarks()
        }

        func getBookmarks() {
            PersistenceManager.retrieveBookmarks { [weak self] result in

                guard let self = self else { return }

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

        func deleteBookmarks(atOffsets offsets: IndexSet) {
            guard let index = offsets.first else { return }
            let bookmark = bookmarks[index]

            PersistenceManager.updateWith(bookmark, actionType: .remove) { [weak self] error in

                guard let self = self else { return }

                if let error = error {
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
