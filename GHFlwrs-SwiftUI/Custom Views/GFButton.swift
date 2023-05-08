//
//  GFButton.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

/// A styled Github Followers button.
///
/// Default modifiers include:
/// + *.headline* text font
/// + frame max width set to *.infinity*
/// + buttonStyle of *.borderedProminent*
/// + internal vertical padding
struct GFButton: View {

    var color: Color
    var labelTitle: String
    var systemImageName: String?
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            buttonLabel
        }
        .buttonStyle(.borderedProminent)
        .frame(maxWidth: .infinity)
        .tint(color)
    }

    @ViewBuilder private var buttonLabel: some View {
        HStack {
            Spacer()
            if let imageName = systemImageName {
                Label(labelTitle, systemImage: imageName)
                    .font(.headline)
            } else {
                Text(labelTitle)
                    .font(.headline)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
