//
//  Follower.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 30.04.2023.
//

import Foundation

struct Follower: Codable, Equatable {

    var login: String
    var avatarUrl: String   // will be converted from snake_case by KeyDecodingStrategy

    static let example = Follower(
        login: "dendden",
        avatarUrl: "https://avatars.githubusercontent.com/u/13221911?v=4"
    )

    static func == (lhs: Follower, rhs: Follower) -> Bool {
        lhs.login == rhs.login
    }
}
