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
        @Published var loadProgressViewOpacity: Double = 0
        @Published var showEmptyState = false

        init(username: String) {
            self.username = username
            getFollowers(username: username, page: 1)
        }

        func getFollowers(username: String, page: Int) {

            loadProgressViewOpacity = 0.8

            NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in

                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.loadProgressViewOpacity = 0
                }

                switch result {
                case .success(let success):
                    if success.count < NetworkManager.shared.followersPerPage {
                        self.hasMoreFollowersToLoad = false
                    }
                    DispatchQueue.main.async {
                        self.followers.append(contentsOf: success)
                        self.lastLoadedFollower = self.followers.last
                        if self.followers.isEmpty {
                            self.showEmptyState = true
                        }
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.networkAlertMessage = failure.rawValue
                        self.showNetworkAlert = true
                    }
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
