//
//  GFItemCardView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import SwiftUI

enum InfoCardType {
    case repo, follower
}

struct GFItemCardView: View {

    @EnvironmentObject var userInfoViewModel: UserInfoView.ViewModel

    let user: User
    let cardType: InfoCardType

    var body: some View {
        GroupBox {
            VStack {
                itemInfoViewsStack
                cardActionButton
            }
        }
        .padding(.horizontal)
    }

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

    private var cardActionButton: GFButton {
        switch cardType {
        case .repo:
            return GFButton(color: .indigo, label: "GitHub Profile", action: userInfoViewModel.showUserWebProfile)
        case .follower:
            return GFButton(color: .green, label: "Get Followers") {
                // show followers screen
            }
        }
    }
}

struct CGItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        GFItemCardView(user: .example, cardType: .follower)
            .environmentObject(UserInfoView.ViewModel(username: "dendden"))
    }
}
