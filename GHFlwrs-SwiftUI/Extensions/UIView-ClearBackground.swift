//
//  UIView-ClearBackground.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 26.04.2023.
//

import SwiftUI

/// A `clear` background for the superview of superview.
///
/// Applied when a transparent effect is needed for current view.
struct ClearBackgroundView: UIViewRepresentable {

    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
