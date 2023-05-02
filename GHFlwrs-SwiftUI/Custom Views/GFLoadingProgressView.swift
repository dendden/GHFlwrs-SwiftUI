//
//  GFLoadingProgressView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

struct GFLoadingProgressView: View {

    @Binding var showProgress: Bool
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            if showProgress {
                Color.systemBackground.opacity(opacity)
                ProgressView()
            }
        }
        .onChange(of: showProgress) { show in
            withAnimation {
                opacity = show ? 0.8 : 0
            }
        }
    }
}
