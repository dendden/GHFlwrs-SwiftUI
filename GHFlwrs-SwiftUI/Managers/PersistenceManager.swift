//
//  PersistenceManager.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {

    enum Files {
        static let bookmarkedUsers = "bookmarked_users.json"
    }

    static var allBookmarkedUsers: [String] = []

    static func updateWith(
        _ bookmark: Follower, actionType: PersistenceActionType,
        completion: @escaping (GFPersistenceError?) -> Void
    ) {

        retrieveBookmarks { result in

            switch result {

            case .success(let bookmarks):

                var updatingBookmarks = bookmarks

                switch actionType {
                case .add:
                    if !updatingBookmarks.contains(bookmark) {
                        updatingBookmarks.append(bookmark)
                        allBookmarkedUsers.append(bookmark.login)
                    } else {
                        completion(.bookmarkExists)
                        return
                    }
                case .remove:
                    updatingBookmarks.removeAll { $0 == bookmark }
                    allBookmarkedUsers.removeAll { $0 == bookmark.login }
                }

                completion(saveBookmarks(updatingBookmarks))

            case .failure(let failure):
                completion(failure)
            }
        }
    }

    static func retrieveBookmarks(completion: @escaping (Result<[Follower], GFPersistenceError>) -> Void) {
        do {
            let bookmarks = try FileManager.default.decodeFromJSON(file: Files.bookmarkedUsers, as: [Follower].self)
            completion(.success(bookmarks))
        } catch GFPersistenceError.dataReadError {
            // file doesn't exist, so it's a first read
            completion(.success([]))
        } catch {
            completion(.failure(.dataDecodeError))
        }
    }

    static func saveBookmarks(_ bookmarks: [Follower]) -> GFPersistenceError? {
        do {
            try FileManager.default.encodeToJSON(file: Files.bookmarkedUsers, data: bookmarks)
            return nil
        } catch GFPersistenceError.dataEncodeError {
            return .dataEncodeError
        } catch {
            return .writeError
        }
    }
}
