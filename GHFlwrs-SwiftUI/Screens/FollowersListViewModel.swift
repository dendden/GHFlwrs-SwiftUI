//
//  FollowersListViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 01.05.2023.
//

import Foundation

/// A selection of alerts that can be triggered by this `ViewModel`.
enum ActiveBookmarkAlert: Identifiable {
    case bookmarkFailure, bookmarkError, bookmarkSuccess

    var id: Int { hashValue }
}

extension FollowersListView {

    /// A `ViewModel` that performs network request to get
    /// user's followers and manages adding current user to bookmarks.
    ///
    /// This `ViewModel` is also responsible for the logic of showing error alerts, displaying ``GFEmptyStateView``,
    /// showing loading progress cover view and managing followers filtered with `searchBar`.
    @MainActor class ViewModel: ObservableObject {

        // MARK: - Internal variables

        var username: String

        /// The page of results returned from network request.
        ///
        /// Number of results per page is defined in ``NetworkManager``.``NetworkManager/followersPerPage``.
        var followersRequestPage = 1

        /// An indicator for whether more pages of followers can be loaded for user.
        ///
        /// If network request for current ``followersRequestPage`` returns less
        /// than ``NetworkManager/followersPerPage`` followers, this indicator
        /// is set to false, otherwise stays true.
        var hasMoreFollowersToLoad = true

        /// The last follower in the array of ``allFollowers``.
        ///
        /// Comparing against this follower when scrolling allows to trigger request
        /// for next page of followers.
        var lastLoadedFollower: Follower?

        /// An indicator of ongoing network request.
        ///
        /// This indicator prevents multiple calls to ``NetworkManager`` for incrementing
        /// ``followersRequestPage`` values
        /// if user hits bottom of ``FollowersGridScrollView`` and pulls multiple times to load more followers.
        var isLoadingMoreFollowers = false

        /// All currently loaded users.
        var allFollowers: [Follower] = []

        /// Followers that match filter in ``filterText`` from `.searchable` modifier
        /// of ``FollowersListView``.
        var filteredFollowers: [Follower] = []

        // MARK: - @Published variables

        /// A trigger for ``FollowersListView`` to display an alert from `ViewModel`.
        @Published var activeBookmarkAlert: ActiveBookmarkAlert?

        /// The text entered in search interaction of ``FollowersListView``.
        @Published var filterText = ""

        /// The list of followers that is published to ``FollowersListView`` for display.
        ///
        /// Depending on filter status, this array can contain either ``allFollowers`` or
        /// ``filteredFollowers``.
        @Published var followersToDisplay: [Follower] = []

        /// A variable that accepts follower selection within ``FollowersGridScrollView``
        /// and triggers display of ``UserInfoView``.
        @Published var selectedFollower: Follower?

        /// A trigger for displaying ``GFAlertView`` by ``FollowersListView`` with
        /// ``GFNetworkError`` description.
        @Published var showNetworkAlert = false

        /// Description of ``GFNetworkError`` to pass as a message into ``GFAlertView``.
        @Published var networkAlertMessage = "no comprendo"

        /// Description of ``GFPersistenceError`` to pass as a message into ``GFAlertView``.
        @Published var bookmarkErrorMessage = "something's wrong"

        /// A trigger for showing and hiding loading progress view bound to network requests.
        @Published var showLoadingProgress = false

        /// A trigger for displaying ``GFEmptyStateView`` if network request for followers
        /// returns an empty array.
        @Published var showEmptyState = false

        // MARK: - Methods

        /// Creates an instance of ``FollowersListView`` ``FollowersListView/ViewModel-swift.class``
        /// - Parameter username: A username of user, whose followers must be displayed.
        init(username: String) {
            self.username = username
            getFollowers(username: username, page: 1)
        }

        /// Performs a network call with ``NetworkManager``.``NetworkManager/getFollowers(for:page:completion:)``
        /// method.
        ///
        /// This method also triggers showing `ProgressLoadingView` prior to network call and hiding it once
        /// the call returns a result.
        /// - Parameters:
        ///   - username: A username of user, whose followers must be retrieved via a network request.
        ///   - page: The page for fetch results.
        private func getFollowers(username: String, page: Int) {

            showLoadingProgress = true

            NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in

                guard let self else { return }

                DispatchQueue.main.async {
                    self.showLoadingProgress = false
                }

                switch result {
                case .success(let followers):
                    if followers.count < NetworkManager.shared.followersPerPage {
                        self.hasMoreFollowersToLoad = false
                    }
                    self.updateUIOnMainThread(with: followers)
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.networkAlertMessage = failure.rawValue
                        self.showNetworkAlert = true
                    }
                }

                self.isLoadingMoreFollowers = false
            }
        }

        /// Accepts new array of followers from a network call and appends it
        /// to own ``allFollowers`` array, then updates UI depending on
        /// whether ``allFollowers`` array is empty or not.
        /// - Parameter followers: A new array of followers to append to
        /// existing array.
        private func updateUIOnMainThread(with followers: [Follower]) {
            allFollowers.append(contentsOf: followers)
            lastLoadedFollower = self.allFollowers.last
            DispatchQueue.main.async {
                if self.allFollowers.isEmpty {
                    self.showEmptyState = true
                } else {
                    self.followersToDisplay = self.allFollowers
                }
            }
        }

        /// Checks if ``FollowerCellView`` that was scrolled to presents the ``lastLoadedFollower`` -
        /// if true, and ``hasMoreFollowersToLoad`` returns true while no ongoing followers request
        /// are registered by ``isLoadingMoreFollowers`` indicator - this method increments the
        /// ``followersRequestPage`` and initiates new request for followers.
        /// - Parameter currentFollower: A follower whose ``FollowerCellView`` has appeared
        /// on scrolling the ``FollowersGridScrollView``.
        func loadMoreFollowers(currentFollower: Follower) {
            guard let lastFollower = lastLoadedFollower else {
                return
            }
            if lastFollower == currentFollower && hasMoreFollowersToLoad && !isLoadingMoreFollowers {
                isLoadingMoreFollowers = true
                followersRequestPage += 1
                getFollowers(username: username, page: followersRequestPage)
            }
        }

        /// Checks if any text was entered into or removed from ``filterText`` by
        /// search interaction, then updates ``followersToDisplay`` variable
        /// accordingly to update the UI.
        func updateSearchResults() {
            if filterText.isEmpty {
                if filteredFollowers.isEmpty {
                    return
                } else {
                    // if search bar BECAME empty after previous filtering
                    followersToDisplay = allFollowers
                    filteredFollowers.removeAll()
                    return
                }
            }

            filteredFollowers = allFollowers.filter {
                $0.login.lowercased().contains(filterText.lowercased())
            }
            followersToDisplay = filteredFollowers
        }

        /// The delegate method called from ``UserInfoView`` to present a new list of
        /// followers for given user in ``FollowersListView``.
        ///
        /// This method resets all configuration variables before performing the network request
        /// for a new list of followers.
        /// - Parameter username: The username of new user, whose followers must be
        /// listed by ``FollowersListView``.
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

        /// Fetches user info with ``NetworkManager``.``NetworkManager/getUserInfo(for:completion:)``
        /// method and calls ``PersistenceManager``
        /// .``PersistenceManager/updateWith(_:actionType:completion:)``
        /// to check for user's bookmarked status and add this user to bookmarks or show alert
        /// informing that current user is already bookmarked.
        ///
        /// This method also triggers showing `ProgressLoadingView` prior to network call and hiding it once
        /// the call returns a result.
        func bookmarkTapped() {

            showLoadingProgress = true

            NetworkManager.shared.getUserInfo(for: username) { [weak self] result in

                guard let self else { return }

                DispatchQueue.main.async {
                    self.showLoadingProgress = false
                }

                switch result {
                case .success(let user):
                    self.bookmarkUser(user)
                case .failure:
                    DispatchQueue.main.async {
                        self.activeBookmarkAlert = .bookmarkFailure
                    }
                }
            }
        }

        /// Creates a ``Follower`` object from provided user and calls
        /// ``PersistenceManager``.``PersistenceManager/updateWith(_:actionType:completion:)``
        /// method to try and add this user to bookmarked.
        /// - Parameter user: A user who should be bookmarked.
        private func bookmarkUser(_ user: User) {
            let bookmark = Follower(login: user.login, avatarUrl: user.avatarUrl)
            PersistenceManager.updateWith(bookmark, actionType: .add) { [weak self] error in
                guard let self else { return }
                if let error {
                    DispatchQueue.main.async {
                        self.bookmarkErrorMessage = error.rawValue
                        self.activeBookmarkAlert = .bookmarkError
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activeBookmarkAlert = .bookmarkSuccess
                    }
                }
            }
        }
    }
}
