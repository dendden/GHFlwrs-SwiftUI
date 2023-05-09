//
//  GFAvatarImageView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

/// A custom-configured `Image` for displaying user avatar images, with
/// a `cornerRadius` of 10 pts and a default ``Images/avatarPlaceholder``
/// image.
///
/// Within it's `.onAppear` modifier this view calls ``NetworkManager``.
/// ``NetworkManager/downloadImage(from:completion:)``
/// method and assigns retrieved image to `self` if request was successful.
///
/// If network request for image fails, this view displays ``Images/avatarPlaceholder`` image.
struct GFAvatarImageView: View {

    /// A `String` representation of image `URL`.
    let avatarUrl: String

    /// An image displayed as ``User`` or ``Follower`` avatar.
    /// Returns a ``Images/avatarPlaceholder`` if image download is unavailable.
    @State private var avatarImage = Images.avatarPlaceholder

    var body: some View {
        avatarImage
            .resizable()
            .cornerRadius(10)
            .aspectRatio(1, contentMode: .fit)
            .onAppear {
                NetworkManager.shared.downloadImage(from: avatarUrl) { image in
                    if let image {
                        avatarImage = image
                    }
                }
            }
    }
}

struct GFAvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        GFAvatarImageView(avatarUrl: "https://avatars.githubusercontent.com/u/13221911?v=4")
    }
}
