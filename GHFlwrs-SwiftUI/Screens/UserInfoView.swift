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
            Group {
                if !viewModel.showProgressView {
                    GeometryReader { geo in
                        VStack(spacing: 20) {
                            GFUserInfoHeaderView(user: viewModel.user!, screenWidth: geo.size.width)

                            GFItemCardView(user: viewModel.user!, cardType: .repo)

                            GFItemCardView(user: viewModel.user!, cardType: .follower)

                            Text("GitHub since \(viewModel.user!.createdAt.shortMonthAndYear)")
                                .gfBody(alignment: .center, numOfLines: 1)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done", role: .cancel, action: dismiss.callAsFunction)
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
