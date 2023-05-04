//
//  UserInfoView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI
import WebKit

struct UserInfoView: View {

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var followersListViewModel: FollowersListView.ViewModel

    @StateObject var viewModel: ViewModel

    init(username: String) {
        self._viewModel = StateObject(wrappedValue: ViewModel(username: username))
    }

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

    private var networkAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Problemo! 🤦🏻",
            alertMessage: $viewModel.networkAlertMessage
        )
    }

    private var userUrlAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Broken link 🤬",
            alertMessage: .constant("It looks like the link to profile on GitHub is invalid.")
        )
    }

    private var zeroFollowersAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Zero means zero",
            alertMessage: .constant("We can't be bothered to refresh the UI for 0 followers, sorry! 😤"),
            buttonTitle: "Sad but true"
        )
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(username: "dendden")
            .environmentObject(FollowersListView.ViewModel(username: "dendden"))
    }
}
