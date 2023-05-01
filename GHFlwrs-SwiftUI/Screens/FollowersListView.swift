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
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.followers, id: \.login) { follower in
                    FollowerCellView(follower: follower)
                        .onAppear {
                            viewModel.loadMoreFollowers(currentFollower: follower)
                        }
                }
            }
        }
        .navigationTitle(viewModel.username)
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $viewModel.showNetworkAlert) {
            showFollowersListOnStack = false
        } content: {
            GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $viewModel.networkAlertMessage)
        }

    }
}

struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListView(username: "Den", showOnStack: .constant(true))
    }
}
