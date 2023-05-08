//
//  GFUserInfoHeaderView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

/// The header of ``UserInfoView``, displaying user's avatar, username,
/// (*optionally*) real name and location, as well as a short bio.
struct GFUserInfoHeaderView: View {

    /// A user whose information must be displayed.
    let user: User

    /// Current screen width which defines proportions of View elements.
    let screenWidth: CGFloat

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {
            // avatar image & 3 lines of labels
            HStack(spacing: 12) {
                GFAvatarImageView(avatarUrl: user.avatarUrl)
                    .frame(width: screenWidth / 4)

                VStack(alignment: .leading) {
                    Text(user.login)
                        .gfTitle(alignment: .leading, fontSize: 34)

                    Spacer()

                    nameAndLocationLabel
                }

                Spacer()
            }
            .frame(height: screenWidth / 4)

            Text(user.bio ?? "*No bio available*")
                .gfBody(alignment: .leading, numOfLines: 3)
        }
        .padding(20)
    }

    /// A `VStack` composed of a subtitle label with user's real name
    /// and a subtitle label with user's location.
    private var nameAndLocationLabel: some View {

        VStack(alignment: .leading, spacing: 6) {
            Text(user.name ?? "")
                .gfSubtitle(fontSize: 18)
            Text("\(Image(systemName: "mappin.and.ellipse"))  \(user.location ?? "*n/a*")")
                .gfSubtitle(fontSize: 18)
        }
    }
}

struct UserInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GFUserInfoHeaderView(user: .example, screenWidth: 414)
    }
}
