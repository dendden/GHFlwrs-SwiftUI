//
//  UserInfoViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import Foundation

/// A selection of alerts that can be triggered by this `ViewModel`.
///
/// An enum dedicated to multiple alerts organization.
///
/// Spotted in `ramzesenok` answer on `StackOverflow`:
/// https://stackoverflow.com/questions/58837007/multiple-sheetispresented-doesnt-work-in-swiftui
enum ActiveUserInfoAlert: Identifiable {
    case networkError, userUrl, zeroFollowers

    var id: Int { hashValue }
}

extension UserInfoView {

    /// A `ViewModel` that performs network request to get user info and manages
    /// triggers to show user's profile in a ``SafariVCWrapper`` view or dismiss
    /// ``UserInfoView`` for a list of user's followers.
    @MainActor class ViewModel: ObservableObject {

        // MARK: - Internal variables

        let username: String
        var user: User?
        var userProfileUrl: URL?

        // MARK: - @Published variables

        /// A trigger for ``UserInfoView`` to display an alert from `ViewModel`.
        @Published var activeAlert: ActiveUserInfoAlert?

        /// A trigger for showing and hiding loading progress view bound to network request.
        @Published var showProgressView = true

        /// Description of ``GFNetworkError`` to pass as a message into ``GFAlertView``.
        @Published var networkAlertMessage = "no comprendo"

        /// A trigger for displaying ``SafariVCWrapper`` view with user's GutHub profile page.
        @Published var showUserProfileWebView = false

        /// A trigger for dismissing ``UserInfoView`` for a list of user's followers.
        @Published var shouldDismissForNewFollowers = false

        // MARK: - Methods

        /// Creates an instance of ``UserInfoView/ViewModel-swift.class``
        /// - Parameter username: The username of user whose information must be displayed.
        init(username: String) {
            self.username = username
            getUserInfo(for: username)
        }

        /// Fetches user info with ``NetworkManager``.``NetworkManager/getUserInfo(for:completion:)``
        /// method.
        ///
        /// If network request fails, this method presents a ``GFAlertView`` with ``GFNetworkError`` description.
        /// - Parameter username: The username of user whose info must be fetched.
        func getUserInfo(for username: String) {
            NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.user = user
                        self.userProfileUrl = URL(string: user.htmlUrl)
                        self.showProgressView = false
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.networkAlertMessage = failure.rawValue
                        self.activeAlert = .networkError
                    }
                }
            }
        }

        /// Checks for valid ``userProfileUrl`` - if `URL` returns nil, a ``GFAlertView``
        /// is triggered by assigning an ``activeAlert``, if `URL` is valid, presentation of
        /// ``SafariVCWrapper`` is triggered by ``showUserProfileWebView`` variable.
        func showUserWebProfile() {
            guard userProfileUrl != nil else {
                self.activeAlert = .userUrl
                return
            }

            showUserProfileWebView = true
        }

        /// Checks user's followers list and displays a ``GFAlertView`` if list is empty by assigning
        /// an ``activeAlert``. If list is not empty - initiates dismiss of ``UserInfoView`` by
        /// activating ``shouldDismissForNewFollowers`` trigger.
        func showUserFollowers() {
            guard user!.followers > 0 else {
                self.activeAlert = .zeroFollowers
                return
            }

            shouldDismissForNewFollowers = true
        }
    }
}
