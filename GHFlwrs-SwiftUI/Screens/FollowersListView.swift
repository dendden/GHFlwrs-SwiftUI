//
//  FollowersListView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

struct FollowersListView: View {

    let username: String

    @Binding var showFollowersListOnStack: Bool

    @State private var followers: [Follower] = []
    @State private var showNetworkAlert = false
    @State private var networkAlertMessage = "no comprendo"

    var body: some View {
        Text("Found \(followers.count) followers.")
            .navigationTitle(username)
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
