//
//  FollowersGridScrollView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 04.05.2023.
//

import SwiftUI

struct FollowersGridScrollView: View {

    @Environment(\.dismissSearch) var dismissSearch
    @Environment(\.isSearching) var isSearching

    @EnvironmentObject var viewModel: FollowersListView.ViewModel

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

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
                    print(">>> dismissing search...")
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

struct FollowersGridScrollView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersGridScrollView()
    }
}
