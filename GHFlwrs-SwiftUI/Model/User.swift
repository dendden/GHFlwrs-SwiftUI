//
//  User.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

/// An object representing full information about a GitHub user.
struct User: Codable {

    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?

    var publicRepos: Int
    var publicGists: Int

    /// URL address of user's profile on github.com.
    var htmlUrl: String

    var following: Int
    var followers: Int
    var followersUrl: String

    /// A date when user joined GitHub.
    var createdAt: Date

    static let example = User(
        login: "Dendden",
        avatarUrl: "https://avatars.githubusercontent.com/u/13221911?v=4",
        name: "Denys Triasunov",
        location: "Kyiv, Ukraine",
        // swiftlint:disable:next line_length
        bio: "iOS developer (Swift, UIKit, SwiftUI), UI/UX designer, author of Box Breathe and Drinkology (both live on App Store).",
        publicRepos: 41,
        publicGists: 0,
        htmlUrl: "https://github.com/dendden",
        following: 1,
        followers: 2,
        followersUrl: "https://api.github.com/users/dendden/followers",
        createdAt: .now
    )
}
