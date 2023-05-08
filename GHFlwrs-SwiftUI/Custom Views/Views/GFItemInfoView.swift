//
//  GFItemInfoView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import SwiftUI

/// A selection of available types of ``User`` parameters that can be
/// displayed by ``GFItemInfoView``.
enum ItemInfoType {
    case repos, gists, followers, following
}

/// A custom view illustrating certain ``User`` parameter within
/// ``GFItemCardView``.
///
/// This view includes an `SFSymbol` image and title label on top
/// and count label centered beneath.
struct GFItemInfoView: View {

    let infoType: ItemInfoType
    let count: Int
    let imageSymbol: String
    let title: String

    /// Creates an instance of ``GFItemInfoView``.
    /// - Parameters:
    ///   - infoType: A type that defines ``imageSymbol`` and ``title``.
    ///   - count: The count of parameter to display.
    init(infoType: ItemInfoType, count: Int) {
        self.infoType = infoType
        self.count = count

        switch infoType {
        case .repos:
            imageSymbol = "folder"
            title = "Public Repos"
        case .gists:
            imageSymbol = "text.alignleft"
            title = "Public Gists"
        case .followers:
            imageSymbol = "heart"
            title = "Followers"
        case .following:
            imageSymbol = "person.2"
            title = "Following"
        }
    }

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: imageSymbol)
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20)

                Text(title)
                    .gfTitle(alignment: .leading, fontSize: 16)
            }

            Text(String(count))
                .gfTitle(alignment: .center, fontSize: 18)
        }
    }
}

struct GFItemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GFItemInfoView(infoType: .repos, count: 32)
    }
}
