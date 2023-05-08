//
//  ContentView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

/// The root `TabBar` View of the app.
struct TabBarView: View {

    /// A toggle that triggers removing all Views from the `Search` tab
    /// `NavigationStack`, returning to ``SearchView``.
    @State private var returnToSearchHome = false

    /// A toggle that triggers removing all Views from the `Bookmarks` tab
    /// `NavigationStack`, returning to ``BookmarksView``.
    @State private var returnToBookmarksHome = false

    /// Currently selected tab.
    @State private var selectedTab = 1

    /// A `Binding` handler that triggers `returnToSearchHome` and
    /// `returnToBookmarksHome` toggles when tabs are tapped.
    var tabSelectionHandler: Binding<Int> {

        Binding(
            get: { selectedTab },
            set: {
                if $0 == selectedTab {
                    if selectedTab == 1 {
                        returnToSearchHome = true
                    }
                    if selectedTab == 2 {
                        returnToBookmarksHome = true
                    }
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

            BookmarksView(returnToBookmarksHome: $returnToBookmarksHome)
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
