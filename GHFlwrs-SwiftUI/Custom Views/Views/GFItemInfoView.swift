//
//  GFItemInfoView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import SwiftUI

enum ItemInfoType {
    case repos, gists, followers, following
}

struct GFItemInfoView: View {

    let infoType: ItemInfoType
    let count: Int
    let imageSymbol: String
    let title: String

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
