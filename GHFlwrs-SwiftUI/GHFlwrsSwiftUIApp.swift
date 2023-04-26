//
//  GHFlwrsSwiftUIApp.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 25.04.2023.
//

import SwiftUI

@main
struct GHFlwrsSwiftUIApp: App {

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
//        UITabBar.appearance().tintColor = .green
    }

    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
