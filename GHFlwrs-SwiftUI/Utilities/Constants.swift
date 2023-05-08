//
//  Constants.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 05.05.2023.
//

import SwiftUI

/// A collection of custom `Images` from `Asset Catalog`.
enum Images {

    static let ghLogo = Image("gh-logo")
    static let avatarPlaceholder = Image("avatar-placeholder")
    static let emptyStateLogo = Image("empty-state-logo")
}

/// A collection of `Images` created with `SFSymbols`.
enum SystemImages {

    static let bookmark = Image(systemName: "bookmark")
    static let search = Image(systemName: "magnifyingglass")
    static let location = Image(systemName: "mappin.and.ellipse")
    static let clear = Image(systemName: "xmark.circle.fill")
}
