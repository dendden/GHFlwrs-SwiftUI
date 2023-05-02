//
//  UserInfoView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

struct UserInfoView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: ViewModel

    init(username: String) {
        self._viewModel = StateObject(wrappedValue: ViewModel(username: username))
    }

    var body: some View {
        NavigationStack {
            if !viewModel.showProgressView {
                GeometryReader { geo in
                    VStack {
                        GFUserInfoHeaderView(user: viewModel.user!, screenWidth: geo.size.width)

                        Spacer()
                    }
                }
                .navigationTitle(viewModel.username)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done", role: .cancel, action: dismiss.callAsFunction)
                    }
                }
            } else {
                ProgressView()
                    .navigationTitle(viewModel.username)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done", role: .cancel, action: dismiss.callAsFunction)
                        }
                    }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showNetworkErrorAlert) {
            dismiss()
        } content: {
            GFAlertView(alertTitle: "Problemo! 🤦🏻", alertMessage: $viewModel.networkAlertMessage)
        }

    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(username: "dendden")
    }
}
