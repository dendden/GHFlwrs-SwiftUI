//
//  FollowersListViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 01.05.2023.
//

import Foundation

extension FollowersListView {
    @MainActor class ViewModel: ObservableObject {

        let username: String

        var followersRequestPage = 1
        var hasMoreFollowersToLoad = true
        var lastLoadedFollower: Follower?

        @Published var followers: [Follower] = []
        @Published var showNetworkAlert = false
        @Published var networkAlertMessage = "no comprendo"

        init(username: String) {
            self.username = username
            getFollowers(username: username, page: 1)
        }

        func getFollowers(username: String, page: Int) {
            NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in

                guard let self = self else { return }

                switch result {
                case .success(let success):
                    if success.count < NetworkManager.shared.followersPerPage {
                        self.hasMoreFollowersToLoad = false
                    }
                    self.followers.append(contentsOf: success)
                    self.lastLoadedFollower = self.followers.last
                case .failure(let failure):
                    self.networkAlertMessage = failure.rawValue
                    self.showNetworkAlert = true
                }
            }
        }

        func loadMoreFollowers(currentFollower: Follower) {
            guard let lastFollower = lastLoadedFollower else {
                return
            }
            if lastFollower == currentFollower && hasMoreFollowersToLoad {
                followersRequestPage += 1
                getFollowers(username: username, page: followersRequestPage)
            }
        }
    }
}
