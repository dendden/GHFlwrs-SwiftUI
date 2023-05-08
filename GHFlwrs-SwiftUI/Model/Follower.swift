//
//  Follower.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

/// An object representing either a GitHub follower or a bookmarked user.
struct Follower: Codable, Equatable, Hashable, Identifiable {

    var login: String
    var avatarUrl: String   // will be converted from snake_case by KeyDecodingStrategy

    static let example = Follower(
        login: "dendden",
        avatarUrl: "https://avatars.githubusercontent.com/u/13221911?v=4"
    )

    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }

    static func == (lhs: Follower, rhs: Follower) -> Bool {
        lhs.login == rhs.login
    }

    var id: String { login }
}
