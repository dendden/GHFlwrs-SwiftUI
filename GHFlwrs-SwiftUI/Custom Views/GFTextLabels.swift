//
//  GFTextLabels.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

extension Text {

    func gfTitle(alignment: TextAlignment, fontSize: CGFloat) -> some View {
        self
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
            .multilineTextAlignment(alignment)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .truncationMode(.tail)
    }

    func gfBody(alignment: TextAlignment, numOfLines: Int) -> some View {
        self
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(alignment)
            .lineLimit(numOfLines)
            .minimumScaleFactor(0.75)
    }
}
