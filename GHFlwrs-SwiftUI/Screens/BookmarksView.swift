//
//  FavoritesView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

struct BookmarksView: View {

    @StateObject var viewModel = ViewModel()

    @Binding var returnToBookmarksHome: Bool
    @State private var showUserFollowers = true

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
                }
            }
            .navigationTitle("Bookmarks")
        }
    }

    func delete(atOffsets offsets: IndexSet) {
        viewModel.deleteBookmarks(atOffsets: offsets)
    }
}
