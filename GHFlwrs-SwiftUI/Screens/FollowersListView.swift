//
//  FollowersListView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

struct FollowersListView: View {

    @StateObject var viewModel: ViewModel

    @Binding var showFollowersListOnStack: Bool

    init(username: String, showOnStack: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: ViewModel(username: username))
        self._showFollowersListOnStack = showOnStack
    }

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

    private var networkAlert: GFAlertView {
        GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $viewModel.networkAlertMessage)
    }

    private var bookmarkButton: some View {
        Button {
            viewModel.bookmarkTapped()
        } label: {
            Image(systemName: "bookmark")
                .symbolVariant(PersistenceManager.allBookmarkedUsers.contains(viewModel.username) ? .fill : .none)
        }
    }

    private var bookmarkErrorAlert: GFAlertView {
        GFAlertView(alertTitle: "Bookmark Error", alertMessage: $viewModel.bookmarkErrorMessage)
    }

    private var bookmarkFailureAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Bookmark Error",
            alertMessage: .constant("There's a problem retrieving sufficient user info to bookmark 🤷🏻‍♂️")
        )
    }

    private var bookmarkSuccessAlert: GFAlertView {
        GFAlertView(
            alertTitle: "Nailed it 📌",
            alertMessage: .constant("You can now find \(viewModel.username) in ⭐️ Favorites tab."),
            buttonTitle: "Sweet"
        )
    }

}

struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListView(username: "mrbombhead", showOnStack: .constant(true))
    }
}
