//
//  SearchView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

struct SearchView: View {

    @FocusState var searchFieldIsFocused: Bool

    @State private var usernameToSearch = ""

    @State private var showUsernameAlert = false

    @State private var pushFollowersList = false

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
                        .focused($searchFieldIsFocused)
                        .onSubmit(pushFollowersListIfValid)

                    Spacer()

                    GFButton(action: pushFollowersListIfValid, color: .green, label: "Get Followers")
                        .padding(.horizontal, 50)
                }
                .padding(.vertical, 48)
            }
            .ignoresSafeArea(.keyboard)
            .navigationDestination(isPresented: $pushFollowersList) {
                FollowersListView(username: usernameToSearch)
            }
        }
        .onTapGesture {
            if searchFieldIsFocused {
                searchFieldIsFocused = false
            }
        }
        .fullScreenCover(isPresented: $showUsernameAlert) {
            GFAlertView(
                alertTitle: "Username No-No",
                alertMessage: "Looks like you forgot to input anything except emptiness in that search field 🥺."
            )
            .background(ClearBackgroundView())
        }
    }

    var isUsernameEntered: Bool {
        !usernameToSearch
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    private func pushFollowersListIfValid() {
        guard isUsernameEntered else {
            showUsernameAlert = true
            return
        }
        pushFollowersList = true
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}