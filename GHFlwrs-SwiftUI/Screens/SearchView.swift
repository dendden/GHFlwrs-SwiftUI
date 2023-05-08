//
//  SearchView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

/// Initial `View` of a `Search` tab, containing a ``GFSearchField``
/// and a ``GFButton`` that pushes ``FollowersListView`` with search
/// results onto   `NavigationController` stack.
struct SearchView: View {

    // MARK: - @State variables

    /// A controller for focus (first responder) state of ``GFSearchField``.
    @FocusState var searchFieldIsFocused: Bool

    /// A `Binding` toggle from ``TabBarView`` that responds to a tap
    /// on Search tab and clears the `NavigationStack` by setting `pushFollowersList`
    /// toggle to `false`.
    @Binding var returnToSearchHome: Bool

    /// A text bound to content of ``GFSearchField``.
    @State private var usernameToSearch = ""

    /// A toggle controlling display of [*invalid username*] alert.
    @State private var showUsernameAlert = false

    /// A toggle that controls pushing ``FollowersListView`` onto
    /// `Navigation Stack` and popping it if ``returnToSearchHome``
    /// toggle gets triggered or an error alert is shown and dismissed on
    /// ``FollowersListView``.
    @State private var pushFollowersList = false

    // MARK: -
    var body: some View {

        VStack {
            Images.ghLogo
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

                GFButton(color: .green, labelTitle: "Get Followers", action: pushFollowersListIfValid)
                    .padding(.horizontal, 50)
            }
            .padding(.vertical, 48)
        }
        .ignoresSafeArea(.keyboard)
        .navigationDestination(isPresented: $pushFollowersList) {
            FollowersListView(username: usernameToSearch, showOnStack: $pushFollowersList)
        }
        .onTapGesture {
            if searchFieldIsFocused {
                searchFieldIsFocused = false
            }
        }
        .onChange(of: returnToSearchHome) { returnHome in
            if returnHome {
                pushFollowersList = false
                returnToSearchHome = false
            }
        }
        .fullScreenCover(isPresented: $showUsernameAlert) {
            GFAlertView(
                alertTitle: "Username No-No",
                alertMessage: .constant(
                    "Looks like you forgot to input anything except emptiness in that search field 🥺."
                )
            )
        }
        .onAppear {
            usernameToSearch = ""
        }
    }

    /// A variable that checks whether any characters except white spaces were
    /// entered into the search field.
    private var isUsernameEntered: Bool {
        !usernameToSearch
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }

    /// Checks `isUsernameEntered` variable: if true, a ``FollowersListVC``
    /// with entered username is created and pushed onto `NavigationController`.
    /// If false,  an alert is shown.
    private func pushFollowersListIfValid() {
        guard isUsernameEntered else {
            showUsernameAlert = true
            return
        }
        pushFollowersList = true
    }
}

// MARK: -
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(returnToSearchHome: .constant(false))
    }
}
