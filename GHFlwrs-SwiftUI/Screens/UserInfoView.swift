//
//  UserInfoView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

struct UserInfoView: View {

    @Environment(\.dismiss) var dismiss

    let user: Follower

    var body: some View {
        NavigationStack {
            Text("User details go here...")
                .navigationTitle(user.login)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done", role: .cancel, action: dismiss.callAsFunction)
                    }
                }
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(user: .example)
    }
}
