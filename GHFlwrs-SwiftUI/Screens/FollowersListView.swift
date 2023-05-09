//
//  FollowersListView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

/// A `View` that displays user's followers in a ``FollowersGridScrollView``.
///
/// If `ViewModel` request returns an empty followers list, this view displays ``GFEmptyStateView``.
/// If network request fails, this view presents a ``GFAlertView`` and
/// dismisses itself from `NavigationStack`, returning to ``SearchView``.
struct FollowersListView: View {

    // MARK: - @State variables

    /// A `ViewModel` that performs network request to get
    /// user's followers and manages adding current user to bookmarks.
    ///
    /// This `ViewModel` is also responsible for the logic of showing error alerts, displaying ``GFEmptyStateView``,
    /// showing loading progress cover view and managing followers filtered with `searchBar`.
    @StateObject var viewModel: ViewModel

    /// A `Binding` toggle from ``SearchView`` that manages dismissing
    /// this view from `NavigationStack` either in response to ``SearchView``
    /// call or as an error alert action.
    @Binding var showFollowersListOnStack: Bool

    // MARK: -
    /// Creates an instance of ``FollowersListView``.
    /// - Parameters:
    ///   - username: A username of user, whose followers must be displayed.
    ///   - showOnStack: A toggle that manages dismissing this view from `NavigationStack`.
    init(username: String, showOnStack: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: ViewModel(username: username))
        self._showFollowersListOnStack = showOnStack
    }

    // MARK: - View variables

    var body: some View {
        Group {
            if viewModel.showEmptyState {
                GFEmptyStateView(
                    message: "This user doesn't have any followers yet. You can be the first! 🥹"
                )
            } else {
                FollowersGridScrollView()
                    .environmentObject(viewModel)
                    .searchable(text: $viewModel.filterText, prompt: "Filter by username")
                    .overlay {
                        GFLoadingProgressView(showProgress: $viewModel.showLoadingProgress)
                    }
                    .fullScreenCover(isPresented: $viewModel.showNetworkAlert) {
                        showFollowersListOnStack = false
                    } content: {
                        networkAlert
                    }
            }
        }
        .navigationTitle(viewModel.username)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                bookmarkButton
            }
        }
        .fullScreenCover(item: $viewModel.activeBookmarkAlert) { bookmarkAlert in
            switch bookmarkAlert {
            case .bookmarkError: bookmarkErrorAlert
            case .bookmarkFailure: bookmarkFailureAlert
            case .bookmarkSuccess: bookmarkSuccessAlert
            }
        }
    }

    /// An alert informing on a network request ``GFNetworkError``.
    ///
    /// When dismissed, this alert should trigger returning to ``SearchView``.
    private var networkAlert: GFAlertView {
        GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $viewModel.networkAlertMessage)
    }

    /// A `toolbar` button for adding current user to bookmarked.
    private var bookmarkButton: some View {
        Button {
            viewModel.bookmarkTapped()
        } label: {
            SystemImages.bookmark
                .symbolVariant(
                    PersistenceManager.allBookmarkedUsers.contains(viewModel.username.lowercased()) ? .fill : .none
                )
        }
    }

    /// An alert conveying ``GFPersistenceError`` description if there was a problem
    /// adding user to bookmarked.
    private var bookmarkErrorAlert: GFAlertView {
        GFAlertView(alertTitle: "Bookmark Error", alertMessage: $viewModel.bookmarkErrorMessage)
    }

    /// An alert informing about a problem during network request for user info to perform
    /// bookmarking action.
    private var bookmarkFailureAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Bookmark Error",
            alertMessage: .constant("There's a problem retrieving sufficient user info to bookmark 🤷🏻‍♂️")
        )
    }

    /// An alert informing about successful bookmarking of current user.
    private var bookmarkSuccessAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Nailed it 📌",
            alertMessage: .constant("You can now find \(viewModel.username) in 📖 Bookmarks tab."),
            buttonTitle: "Sweet"
        )
    }

}

// MARK: -
struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListView(username: "mrbombhead", showOnStack: .constant(true))
    }
}
