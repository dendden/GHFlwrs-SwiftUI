//
//  FollowerCellView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 30.04.2023.
//

import SwiftUI

struct FollowerCellView: View {

    @StateObject var viewModel: ViewModel

    init(follower: Follower) {
        let viewModel = ViewModel(follower: follower)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        VStack(spacing: 12) {
            viewModel.avatarImage
                .resizable()
                .cornerRadius(10)
                .aspectRatio(1, contentMode: .fit)

            Text(viewModel.follower.login)
                .gfTitle(alignment: .center, fontSize: 16)
                .frame(height: 20)
        }
        .padding(8)
    }

}

struct FollowerCellView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerCellView(follower: .example)
    }
}
