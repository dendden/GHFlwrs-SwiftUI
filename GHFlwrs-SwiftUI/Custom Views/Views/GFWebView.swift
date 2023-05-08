//
//  GFWebView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import SafariServices
import SwiftUI
import WebKit

/// A SwiftUI wrapper for `SFSafariViewController`.
struct SafariVCWrapper: UIViewControllerRepresentable {

    let urlToShow: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        let safariVC = SFSafariViewController(url: urlToShow)
        safariVC.preferredControlTintColor = .green

        return safariVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

/// A view that presents an instance of ``SafariVCWrapper`` and opens
/// the provided `URL`.
struct GFWebView: View {

    @Environment(\.dismiss) var dismiss

    /// `URL` to open with ``SafariVCWrapper``.
    var urlToShow: URL

    var body: some View {
        SafariVCWrapper(urlToShow: self.urlToShow)
    }
}
