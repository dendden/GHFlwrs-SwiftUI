//
//  GFWebView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 03.05.2023.
//

import SafariServices
import SwiftUI
import WebKit

struct SafariVCWrapper: UIViewControllerRepresentable {

    let urlToShow: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        let safariVC = SFSafariViewController(url: urlToShow)
        safariVC.preferredControlTintColor = .green

        return safariVC
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct GFWebView: View {

    @Environment(\.dismiss) var dismiss

    var urlToShow: URL

    var body: some View {
        SafariVCWrapper(urlToShow: self.urlToShow)
    }
}
