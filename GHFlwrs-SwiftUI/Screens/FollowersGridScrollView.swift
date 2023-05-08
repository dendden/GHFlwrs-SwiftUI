//
//  FollowersGridScrollView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 04.05.2023.
//

import SwiftUI

/// A collection listing user's followers in a 3-column `LazyVGrid` of ``FollowerCellView`` cells.
///
/// This collection view informs ``viewModel`` about follower selection action,
/// scrolling to last element in collection for loading next page of followers, animates
/// presentation of filtered followers and displays ``UserInfoView`` sheet upon
/// follower selection.
struct FollowersGridScrollView: View {

    // MARK: - @Environment variables

    @Environment(\.dismissSearch) var dismissSearch
    @Environment(\.isSearching) var isSearching

    /// A `ViewModel` that performs network request to get
    /// user's followers and manages adding current user to bookmarks.
    ///
    /// This `ViewModel` is also responsible for the logic of showing error alerts, displaying ``GFEmptyStateView``,
    /// showing loading progress cover view and managing followers filtered with `searchBar`.
    @EnvironmentObject var viewModel: FollowersListView.ViewModel

    // MARK: - Struct variables

    /// A 3-column `LazyVGrid` layout.
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)

    // MARK: -
    var body: some View {

        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.followersToDisplay, id: \.login) { follower in
                    FollowerCellView(follower: follower)
                        .onAppear {
                            viewModel.loadMoreFollowers(currentFollower: follower)
                        }
                        .onTapGesture {
                            viewModel.selectedFollower = follower
                        }
                }
            }
            .padding(.horizontal)
            .onChange(of: viewModel.filterText) { _ in
                withAnimation {
                    viewModel.updateSearchResults()
                }
            }
            .onChange(of: viewModel.selectedFollower) { _ in
                if isSearching {
                    dismissSearch()
                }
            }
            .sheet(item: $viewModel.selectedFollower) { follower in
                UserInfoView(username: follower.login)
                    .environmentObject(viewModel)
            }
        }
    }
}

// MARK: -
struct FollowersGridScrollView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersGridScrollView()
    }
}
