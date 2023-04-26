//
//  SearchView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

struct SearchView: View {

    @State private var usernameToSearch = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .navigationTitle("Search")
                VStack {
                    GFSearchField(searchPhrase: $usernameToSearch)
                    GFButton(label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }, action: {
                        // search code here
                    }, color: .green)
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
