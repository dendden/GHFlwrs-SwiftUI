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
    @Binding var alertMessage: String
    let buttonTitle: String = "OK"

    @State private var alertContainerOpacity: CGFloat = 0
    @State private var alertContainerScale: CGFloat = 0.7

    var body: some View {

        ZStack {

            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation {
                        alertContainerOpacity = 1
                        alertContainerScale = 1
                    }
                }

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

                GFButton(color: .pink, label: "OK", action: dismissAlert)
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
            .opacity(alertContainerOpacity)
            .scaleEffect(alertContainerScale)
        }
        .background(ClearBackgroundView())
    }

    private func dismissAlert() {
        withAnimation {
            alertContainerOpacity = 0
            alertContainerScale = 0.7
            dismiss()
        }
    }
}

struct GFAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GFAlertView(alertTitle: "Oops..", alertMessage: .constant("Something must have gone wrong in there.."))
    }
}
