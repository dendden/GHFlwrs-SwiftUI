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
struct GFButton<Label>: View where Label: View {

    var label: () -> Label
    var action: () -> Void
    var color: Color

    var body: some View {
        Button(action: self.action, label: self.label)
            .foregroundColor(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(color)
            .cornerRadius(10)
    }
}
