//
//  GFSearchField.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

/// A style Github Followers Text Field.
///
/// Default modifiers include:
/// + **Font**: '.title2', lineLimit: 1, min. scale factor: 0.4, text alignment: '.center'
/// + autocorrection and autocapitalization disabled
/// + cursor tint set to `.primary`
/// + submit key of type `.go`
/// + frame max width set to *.infinity*
/// + background color of `tertiarySystemBackground`
/// + border color of `systemGray4`, border width of 2
/// + corner radius of 10
/// + internal vertical padding
/// + prompt of format "<``SystemImages/search`` SFSymbol> *Search username*"
struct GFSearchField: View {

    @Binding var searchPhrase: String

    var body: some View {

        TextField(
            "Search username",
            text: $searchPhrase,
            prompt: Text("\(SystemImages.search) Search username")
        )
        .clearButton(text: $searchPhrase)
        .font(.title2)
        .lineLimit(1)
        .minimumScaleFactor(0.4)
        .multilineTextAlignment(.center)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
        .tint(.primary)
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .submitLabel(.go)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.tertiarySystemBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.systemGray4, lineWidth: 2)
        )
    }
}
