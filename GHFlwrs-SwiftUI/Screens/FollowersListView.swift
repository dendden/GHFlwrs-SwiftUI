//
//  FollowersListView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

struct FollowersListView: View {

    @StateObject var viewModel: ViewModel

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    @Binding var showFollowersListOnStack: Bool

    init(username: String, showOnStack: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: ViewModel(username: username))
        self._showFollowersListOnStack = showOnStack
    }

    var body: some View {
        if viewModel.showEmptyState {
            GFEmptyStateView(
                message: "This user doesn't have any followers yet. You can be the first! 🥹"
            )
            .navigationTitle(viewModel.username)
            .navigationBarTitleDisplayMode(.large)
        } else {
            followersGridView
        }
    }

    private var followersGridView: some View {
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
            .searchable(text: $viewModel.filterText, prompt: "Search username")
            .onChange(of: viewModel.filterText) { _ in
                withAnimation {
                    viewModel.updateSearchResults()
                }
            }
            .sheet(item: $viewModel.selectedFollower) { follower in
                UserInfoView(user: follower)
            }
        }
        .navigationTitle(viewModel.username)
        .navigationBarTitleDisplayMode(.large)
        .overlay {
            ZStack {
                if viewModel.loadProgressViewOpacity > 0 {
                    Color.systemBackground.opacity(viewModel.loadProgressViewOpacity)
                    ProgressView()
                }
            }
        }
        .animation(.default, value: viewModel.loadProgressViewOpacity)
        .fullScreenCover(isPresented: $viewModel.showNetworkAlert) {
            showFollowersListOnStack = false
        } content: {
            GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $viewModel.networkAlertMessage)
        }
    }
}

struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListView(username: "mrbombhead", showOnStack: .constant(true))
    }
}
