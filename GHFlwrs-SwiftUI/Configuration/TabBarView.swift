//
//  ContentView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

struct TabBarView: View {

    @State private var returnToSearchHome = false
    @State private var selectedTab = 1

    var tabSelectionHandler: Binding<Int> {
        Binding(
            get: { selectedTab },
            set: {
                if $0 == selectedTab {
                    returnToSearchHome = true
                }
                self.selectedTab = $0
            }
        )
    }

    var body: some View {
        TabView(selection: tabSelectionHandler) {

            NavigationStack {
                SearchView(returnToSearchHome: $returnToSearchHome)
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(1)

            BookmarksView()
                .tabItem {
                    Label("Bookmarks", systemImage: "book")
                }
                .tag(2)
        }
        .tint(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
