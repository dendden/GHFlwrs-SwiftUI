//
//  FavoritesView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

struct BookmarksView: View {
    var body: some View {
        NavigationStack {
            Color.pink
                .navigationTitle("Bookmarks")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarksView()
    }
}
