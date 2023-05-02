//
//  GFUserInfoHeaderView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

struct GFUserInfoHeaderView: View {

    let user: User
    let screenWidth: CGFloat

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {
            // avatar image 3 lines of labels
            HStack(spacing: 12) {
                GFAvatarImageView(avatarUrl: user.avatarUrl)
                    .frame(width: screenWidth / 4)

                VStack(alignment: .leading) {
                    Text(user.login)
                        .gfTitle(alignment: .leading, fontSize: 34)

                    Spacer()

                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.name ?? "")
                            .gfSubtitle(fontSize: 18)
                        Text("\(Image(systemName: "mappin.and.ellipse"))  \(user.location ?? "*n/a*")")
                            .gfSubtitle(fontSize: 18)
                    }
                }

                Spacer()
            }
            .frame(height: screenWidth / 4)

            Text(user.bio ?? "*No bio available*")
                .gfBody(alignment: .leading, numOfLines: 3)
        }
        .padding(20)
    }
}

struct UserInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GFUserInfoHeaderView(user: .example, screenWidth: 414)
    }
}
