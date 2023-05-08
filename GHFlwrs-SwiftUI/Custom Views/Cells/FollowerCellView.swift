//
//  FollowerCellView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 30.04.2023.
//

import SwiftUI

/// A collection cell displaying follower's ``GFAvatarImageView`` and username
/// in vertical alignment.
struct FollowerCellView: View {

    /// A follower whose avatar and username must be displayed in cell.
    let follower: Follower

    var body: some View {

        VStack(spacing: 12) {
            GFAvatarImageView(avatarUrl: follower.avatarUrl)

            Text(follower.login)
                .gfTitle(alignment: .center, fontSize: 16)
                .frame(height: 20)
        }
        .padding(8)
    }

}

struct FollowerCellView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerCellView(follower: .example)
    }
}
