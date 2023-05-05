//
//  TextField-ClearButton.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 05.05.2023.
//

import SwiftUI

struct ClearTextButton: ViewModifier {
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
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearTextButton(text: text))
    }
}
