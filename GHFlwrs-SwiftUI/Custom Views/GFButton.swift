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
/// + *white* text color
/// + *.headline* text font
/// + frame max width set to *.infinity*
/// + corner radius of 10
/// + internal vertical padding
struct GFButton: View {

    var color: Color
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Spacer()
                Text(label)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        .background(color)
        .cornerRadius(10)
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}
