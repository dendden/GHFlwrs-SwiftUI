//
//  UserInfoViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import Foundation

extension UserInfoView {
    @MainActor class ViewModel: ObservableObject {

        let username: String
        var user: User?
        var userProfileUrl: URL?

        @Published var showProgressView = true
        @Published var showNetworkErrorAlert = false
        @Published var networkAlertMessage = "no comprendo"

        @Published var showUserProfileWebView = false
        @Published var showUserUrlErrorAlert = false

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
                        self.showNetworkErrorAlert = true
                    }
                }
            }
        }

        func showUserWebProfile() {
            guard userProfileUrl != nil else {
                showUserUrlErrorAlert = true
                return
            }

            showUserProfileWebView = true
        }
    }
}
