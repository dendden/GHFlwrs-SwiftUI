//
//  GFAlertView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

struct GFAlertView: View {

    @Environment(\.dismiss) var dismiss

    let alertTitle: String
    let alertMessage: String
    let buttonTitle: String = "OK"

    var body: some View {

        ZStack {

            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)

            VStack {
                Text(alertTitle)
                    .gfTitle(alignment: .center, fontSize: 20)
                    .padding(.top)
                    .padding(.horizontal, 20)

                Spacer()

                Text(alertMessage)
                    .gfBody(alignment: .center, numOfLines: 4)
                    .padding(.horizontal, 20)

                Spacer()

                GFButton(action: dismiss.callAsFunction, color: .pink, label: "OK")
                .padding(.bottom)
                .padding(.horizontal, 20)
            }
            .frame(width: 280, height: 220)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.systemBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.white, lineWidth: 2)
            )
        }
    }
}

struct GFAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GFAlertView(alertTitle: "Oops..", alertMessage: "Something must have gone wrong in there..")
    }
}
