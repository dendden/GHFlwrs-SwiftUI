//
//  TextField-ClearButton.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 05.05.2023.
//

import SwiftUI

/// A `TextField` modifier that adds `x` button to the right,
/// which clears all text content.
struct ClearTextButton: ViewModifier {

    /// `TextField` content to clear.
    @Binding var text: String

    func body(content: Content) -> some View {
        HStack {
            content

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    SystemImages.clear
                        .foregroundColor(.primary.opacity(0.25))
                }
                .padding(.trailing, 6)
            }
        }
    }
}

extension TextField {

    /// Adds a `clear` button in a form of `xmark` on the right side of `TextField`.
    /// - Parameter text: Text string to clear.
    /// - Returns: An empty `TextField`.
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearTextButton(text: text))
    }
}
