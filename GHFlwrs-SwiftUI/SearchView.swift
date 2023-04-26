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

            VStack {
                Image("gh-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 50)
                    .padding(.top, 80)

                Spacer()

                VStack {
                    GFSearchField(searchPhrase: $usernameToSearch)
                        .padding(.horizontal, 50)

                    Spacer()

                    GFButton(label: {
                        Text("Get Followers")
                    }, action: {
                        // search code here
                    }, color: .green)
                    .padding(.horizontal, 50)
                }
                .padding(.vertical, 48)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
