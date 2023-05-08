//
//  GFLoadingProgressView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 02.05.2023.
//

import SwiftUI

/// A progress view displayed as an overlay on views that perform
/// networking requests.
///
/// Progress view appearance and dismissal are animated.
struct GFLoadingProgressView: View {

    /// A toggle bound to hosting view that defines showing/dismissing
    /// of progress view.
    @Binding var showProgress: Bool

    /// An animation controller for progress view appearance and dismissal.
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
