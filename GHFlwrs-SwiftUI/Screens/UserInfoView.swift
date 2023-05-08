//
//  UserInfoView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI
import WebKit

/// A `View` that presents detailed information about the user selected
/// from ``FollowersGridScrollView`` collection.
struct UserInfoView: View {

    // MARK: - @State variables

    @Environment(\.dismiss) var dismiss

    /// A `ViewModel` that performs network request to get user's followers.
    @EnvironmentObject var followersListViewModel: FollowersListView.ViewModel

    /// A `ViewModel` that performs network request to get user info and manages
    /// triggers to show user's profile in a ``SafariVCWrapper`` view or dismiss
    /// ``UserInfoView`` for a list of user's followers.
    @StateObject var viewModel: ViewModel

    // MARK: -

    /// Creates an instance of ``UserInfoView``.
    /// - Parameter username: The username of user whose information must be displayed.
    init(username: String) {
        self._viewModel = StateObject(wrappedValue: ViewModel(username: username))
    }

    // MARK: - View variables

    var body: some View {
        NavigationStack {
            Group {
                if !viewModel.showProgressView {
                    GeometryReader { geo in
                        VStack(spacing: 20) {
                            GFUserInfoHeaderView(user: viewModel.user!, screenWidth: geo.size.width)

                            GFItemCardView(user: viewModel.user!, cardType: .repo)
                                .environmentObject(viewModel)

                            GFItemCardView(user: viewModel.user!, cardType: .follower)
                                .environmentObject(viewModel)

                            Text("GitHub since \(viewModel.user!.createdAt.shortMonthAndYear)")
                                .gfBody(alignment: .center, numOfLines: 1)
                        }
                        .sheet(isPresented: $viewModel.showUserProfileWebView) {
                            GFWebView(urlToShow: viewModel.userProfileUrl!)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", role: .cancel, action: dismiss.callAsFunction)
                }
            }
        }
        .onChange(of: viewModel.shouldDismissForNewFollowers) { shouldDismiss in
            if shouldDismiss {
                followersListViewModel.showFollowersOfUser(username: viewModel.username)
                dismiss()
            }
        }
        .fullScreenCover(
            item: $viewModel.activeAlert,
            onDismiss: viewModel.activeAlert == .networkError ? dismiss.callAsFunction : nil) { alert in

            switch alert {
            case .networkError: networkAlert
            case .userUrl: userUrlAlert
            case .zeroFollowers: zeroFollowersAlert
            }
        }
    }

    /// An alert informing on a network request ``GFNetworkError``.
    ///
    /// When dismissed, this alert should also trigger dismissing this `View`.
    private var networkAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Problemo! 🤦🏻",
            alertMessage: $viewModel.networkAlertMessage
        )
    }

    /// An alert informing about invalid link to user's GitHub profile.
    private var userUrlAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Broken link 🤬",
            alertMessage: .constant("It looks like the link to profile on GitHub is invalid.")
        )
    }

    /// An alert informing that user's followers list is empty.
    private var zeroFollowersAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Zero means zero",
            alertMessage: .constant("We can't be bothered to refresh the UI for 0 followers, sorry! 😤"),
            buttonTitle: "Sad but true"
        )
    }
}

// MARK: -
struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(username: "dendden")
            .environmentObject(FollowersListView.ViewModel(username: "dendden"))
    }
}
