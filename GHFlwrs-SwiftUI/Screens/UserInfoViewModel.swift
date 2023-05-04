//
//  UserInfoViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import Foundation

/// An enum dedicated to multiple alerts organization.
///
/// Spotted in `ramzesenok` answer on `StackOverflow`:
/// https://stackoverflow.com/questions/58837007/multiple-sheetispresented-doesnt-work-in-swiftui
enum ActiveUserInfoAlert: Identifiable {
    case networkError, userUrl, zeroFollowers

    var id: Int { hashValue }
}

extension UserInfoView {
    @MainActor class ViewModel: ObservableObject {

        let username: String
        var user: User?
        var userProfileUrl: URL?

        @Published var activeAlert: ActiveUserInfoAlert?

        @Published var showProgressView = true
        @Published var networkAlertMessage = "no comprendo"
        @Published var showUserProfileWebView = false
        @Published var shouldDismissForNewFollowers = false

        init(username: String) {
            self.username = username
            getUserInfo(for: username)
        }

        func getUserInfo(for username: String) {
            NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
                guard let self = self else { return }
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

        func showUserWebProfile() {
            guard userProfileUrl != nil else {
                self.activeAlert = .userUrl
                return
            }

            showUserProfileWebView = true
        }

        func showUserFollowers() {
            guard user!.followers > 0 else {
                self.activeAlert = .zeroFollowers
                return
            }

            shouldDismissForNewFollowers = true
        }
    }
}
