//
//  FollowersListViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 01.05.2023.
//

import Foundation

extension FollowersListView {
    @MainActor class ViewModel: ObservableObject {

        var username: String

        var followersRequestPage = 1
        var hasMoreFollowersToLoad = true
        var lastLoadedFollower: Follower?

        var allFollowers: [Follower] = []
        var filteredFollowers: [Follower] = []

        @Published var filterText = ""
        @Published var followersToDisplay: [Follower] = []
        @Published var selectedFollower: Follower?
        @Published var showNetworkAlert = false
        @Published var networkAlertMessage = "no comprendo"
        @Published var showLoadingProgress = false
        @Published var showEmptyState = false

        init(username: String) {
            self.username = username
            getFollowers(username: username, page: 1)
        }

        func getFollowers(username: String, page: Int) {

            showLoadingProgress = true

            NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in

                guard let self = self else { return }

                DispatchQueue.main.async {
                    self.showLoadingProgress = false
                }

                switch result {
                case .success(let success):
                    if success.count < NetworkManager.shared.followersPerPage {
                        self.hasMoreFollowersToLoad = false
                    }
                    DispatchQueue.main.async {
                        self.allFollowers.append(contentsOf: success)
                        self.lastLoadedFollower = self.allFollowers.last
                        if self.allFollowers.isEmpty {
                            self.showEmptyState = true
                        } else {
                            self.updateDisplayedFollowers(with: self.allFollowers)
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

        func updateDisplayedFollowers(with followers: [Follower]) {
            followersToDisplay = followers
        }

        func updateSearchResults() {
            if filterText.isEmpty {
                if filteredFollowers.isEmpty {
                    return
                } else {
                    // if search bar BECAME empty after previous filtering
                    updateDisplayedFollowers(with: allFollowers)
                    filteredFollowers.removeAll()
                    return
                }
            }

            filteredFollowers = allFollowers.filter {
                $0.login.lowercased().contains(filterText.lowercased())
            }
            updateDisplayedFollowers(with: filteredFollowers)
        }

        func showFollowersOfUser(username: String) {

            self.username = username

            followersRequestPage = 1
            hasMoreFollowersToLoad = true
            lastLoadedFollower = nil
            allFollowers.removeAll()
            filteredFollowers.removeAll()
            followersToDisplay.removeAll()

            getFollowers(username: username, page: followersRequestPage)
        }
    }
}
