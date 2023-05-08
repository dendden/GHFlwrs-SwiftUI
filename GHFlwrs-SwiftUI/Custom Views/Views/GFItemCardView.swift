//
//  GFItemCardView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import SwiftUI

/// A selection of ``GFItemCardView`` types.
enum InfoCardType {
    case repo, follower
}

/// An card view to display in ``UserInfoView`` with ``User`` parameters
/// and actions to perform on this user.
struct GFItemCardView: View {

    /// A `viewModel` class of ``UserInfoView`` whose methods are executed
    /// as actions for card view's button.
    @EnvironmentObject var userInfoViewModel: UserInfoView.ViewModel

    // MARK: - Struct variables

    /// A ``User`` whose information is displayed in info card view.
    let user: User

    /// Type of information that the card displays (*repos&gists* or *followers/following*).
    let cardType: InfoCardType

    // MARK: - View variables
    var body: some View {
        GroupBox {
            VStack {
                itemInfoViewsStack
                cardActionButton
            }
        }
        .padding(.horizontal)
    }

    /// A horizontal stack containing two ``GFItemInfoView`` views.
    ///
    /// ``InfoCardType`` of views displayed in stack is defined by ``cardType`` variable.
    @ViewBuilder private var itemInfoViewsStack: some View {
        switch cardType {
        case .repo:
            HStack {
                GFItemInfoView(infoType: .repos, count: user.publicRepos)
                    .offset(x: 3)
                Spacer()
                GFItemInfoView(infoType: .gists, count: user.publicGists)
            }
        case .follower:
            HStack {
                GFItemInfoView(infoType: .followers, count: user.followers)
                    .offset(x: 3)
                Spacer()
                GFItemInfoView(infoType: .following, count: user.following)
            }
        }
    }

    /// A button that triggers ``userInfoViewModel`` method to perform on this user.
    private var cardActionButton: GFButton {
        switch cardType {
        case .repo:
            return GFButton(
                color: .indigo,
                labelTitle: "GitHub Profile",
                systemImageName: "person",
                action: userInfoViewModel.showUserWebProfile
            )
        case .follower:
            return GFButton(
                color: .green,
                labelTitle: "Get Followers",
                systemImageName: "person.3",
                action: userInfoViewModel.showUserFollowers
            )
        }
    }
}

// MARK: -
struct CGItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        GFItemCardView(user: .example, cardType: .follower)
            .environmentObject(UserInfoView.ViewModel(username: "dendden"))
    }
}
