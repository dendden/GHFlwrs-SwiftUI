//
//  FollowersListView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

struct FollowersListView: View {

    let username: String

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    @Binding var showFollowersListOnStack: Bool

    @State private var followers: [Follower] = []
    @State private var showNetworkAlert = false
    @State private var networkAlertMessage = "no comprendo"

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(followers, id: \.login) { follower in
                    FollowerCellView(follower: follower)
                }
            }
            .onAppear {
                NetworkManager.shared.getFollowers(for: username, page: 1) { result in
                    switch result {
                    case .success(let success):
                        self.followers = success
                    case .failure(let failure):
                        self.networkAlertMessage = failure.rawValue
                        self.showNetworkAlert = true
                    }
                }
            }
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $showNetworkAlert) {
            showFollowersListOnStack = false
        } content: {
            GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $networkAlertMessage)
        }

    }
}

struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListView(username: "Den", showFollowersListOnStack: .constant(true))
    }
}
