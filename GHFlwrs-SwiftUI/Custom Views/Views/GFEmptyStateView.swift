//
//  GFEmptyStateView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

struct GFEmptyStateView: View {

    let message: String

    var body: some View {

        GeometryReader { geo in
            VStack(alignment: .leading) {
                Text(message)
                    .gfTitle(alignment: .leading, fontSize: 28, lineLimit: 3)
                    .foregroundColor(.secondary)
                    .frame(width: geo.size.width * 0.7, height: 200)
                    .padding(.leading, 35)

                Spacer()

                Images.emptyStateLogo
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 1.3, height: geo.size.width * 1.3)
                    .offset(x: 120, y: 70)
            }
        }
    }
}

struct GFEmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        GFEmptyStateView(message: "No followers for this user yet.")
    }
}
