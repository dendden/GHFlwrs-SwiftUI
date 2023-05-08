//
//  BookmarkCellView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 04.05.2023.
//

import SwiftUI

/// A table cell displaying ``GFAvatarImageView`` and username of a
/// bookmarked user in horizontal alignment.
struct BookmarkCellView: View {

    /// A user whose avatar and username must be displayed in cell.
    let bookmark: Follower

    var body: some View {
        HStack(spacing: 24) {
            GFAvatarImageView(avatarUrl: bookmark.avatarUrl)
                .frame(width: 60, height: 60)

            Text(bookmark.login)
                .gfTitle(alignment: .leading, fontSize: 26)
        }
    }
}

struct BookmarkCellView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkCellView(bookmark: .example)
    }
}
