//
//  GFAvatarImageView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

struct GFAvatarImageView: View {

    let avatarUrl: String

    @State private var avatarImage = Images.avatarPlaceholder

    var body: some View {
        avatarImage
            .resizable()
            .cornerRadius(10)
            .aspectRatio(1, contentMode: .fit)
            .onAppear {
                NetworkManager.shared.downloadImage(from: avatarUrl) { image in
                    if let image = image {
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
