//
//  FavoritesView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

/// A `View` that lists all bookmarked users in a `List` of ``BookmarkCellView`` and enables
/// deleting individual bookmarks.
struct BookmarksView: View {

    // MARK: - @State variables

    /// A `ViewController` that interacts with ``PersistenceManager`` for listing
    /// all bookmarked users and deleting individual bookmarks.
    @StateObject var viewModel = ViewModel()

    /// A `Binding` toggle from ``TabBarView`` that responds to a tap
    /// on Bookmarks tab and clears the `NavigationStack` by setting `showUserFollowers`
    /// toggle to `false`.
    @Binding var returnToBookmarksHome: Bool

    /// A toggle that controls pushing ``FollowersListView`` onto
    /// `Navigation Stack` and popping it if ``returnToBookmarksHome``
    /// toggle gets triggered or an error alert is shown and dismissed on
    /// ``FollowersListView``.
    @State private var showUserFollowers = true

    // MARK: -
    var body: some View {

        NavigationStack(path: $viewModel.selectedBookmarks) {
            Group {
                if viewModel.showEmptyState {
                    GFEmptyStateView(message: "Your bookmarked users will appear here.")
                } else {
                    List {
                        ForEach(viewModel.bookmarks) { bookmark in
                            NavigationLink(value: bookmark) {
                                BookmarkCellView(bookmark: bookmark)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .navigationDestination(for: Follower.self) { bookmark in
                        FollowersListView(username: bookmark.login, showOnStack: $showUserFollowers)
                    }
                    .onChange(of: returnToBookmarksHome) { shouldReturn in
                        if shouldReturn {
                            viewModel.selectedBookmarks.removeAll()
                            returnToBookmarksHome = false
                        }
                    }
                    .onChange(of: showUserFollowers) { showFollowers in
                        if !showFollowers {
                            viewModel.selectedBookmarks.removeAll()
                            showUserFollowers = true
                        }
                    }
                    .fullScreenCover(isPresented: $viewModel.showBookmarksRetrieveError) {
                        GFAlertView(alertTitle: "Something went wrong", alertMessage: $viewModel.bookmarksErrorMessage)
                    }
                }
            }
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.getBookmarks()
            }
        }
    }

    // MARK: -
    func delete(atOffsets offsets: IndexSet) {
        viewModel.deleteBookmarks(atOffsets: offsets)
    }
}
