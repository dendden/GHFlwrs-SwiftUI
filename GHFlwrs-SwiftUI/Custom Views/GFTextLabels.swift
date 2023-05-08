//
//  GFTextLabels.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

extension Text {

    /// A custom `Text` modifier configured for use with title texts.
    ///
    /// Label appearance includes:
    /// + default **lineLimit** of 1
    /// + **bold** font weight
    /// + **rounded** font design
    /// + **.label** font color
    /// + **tail** truncation mode
    /// + **0.85** min scale factor.
    func gfTitle(alignment: TextAlignment, fontSize: CGFloat, lineLimit: Int = 1) -> some View {
        self
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .minimumScaleFactor(0.85)
            .truncationMode(.tail)
    }

    /// A custom `Text` modifier configured for use with secondary title texts.
    ///
    /// Label appearance includes:
    /// + default **lineLimit** of 1
    /// + default **.leading** text alignment
    /// + **medium** font weight
    /// + **rounded** font design
    /// + **.secondary** font color
    /// + **tail** truncation mode
    /// + **0.85** min scale factor.
    func gfSubtitle(fontSize: CGFloat, alignment: TextAlignment = .leading, lineLimit: Int = 1) -> some View {
        self
            .font(.system(size: fontSize, weight: .medium, design: .rounded))
            .foregroundColor(.secondary)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
            .minimumScaleFactor(0.85)
            .truncationMode(.tail)
    }

    /// A custom `Text` modifier configured for use with plain body texts.
    ///
    /// Label appearance includes:
    /// + **.body** font style
    /// + **.secondary** font color
    /// + **0.75** min scale factor.
    func gfBody(alignment: TextAlignment, numOfLines: Int) -> some View {
        self
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(alignment)
            .lineLimit(numOfLines)
            .minimumScaleFactor(0.75)
    }
}
