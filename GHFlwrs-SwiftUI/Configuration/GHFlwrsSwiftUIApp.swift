//
//  GHFlwrsSwiftUIApp.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

@main
struct GHFlwrsSwiftUIApp: App {

    init() {

        PersistenceManager.retrieveBookmarks { result in
            switch result {
            case .success(let bookmarks):
                PersistenceManager.allBookmarkedUsers = bookmarks.map { $0.login }
            case .failure:
                fatalError("Unable to establish bookmarks persistence process.")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
