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
                    .searchable(text: $viewModel.filterText, prompt: "Search username")
                    .overlay {
                        GFLoadingProgressView(showProgress: $viewModel.showLoadingProgress)
                    }
                    .fullScreenCover(isPresented: $viewModel.showNetworkAlert) {
                        showFollowersListOnStack = false
                    } content: {
                        GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $viewModel.networkAlertMessage)
                    }
            }
        }
        .navigationTitle(viewModel.username)
        .navigationBarTitleDisplayMode(.large)
    }

}

struct FollowersListView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListView(username: "mrbombhead", showOnStack: .constant(true))
    }
}
