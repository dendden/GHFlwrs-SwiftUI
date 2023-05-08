//
//  PersistenceManager.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 04.05.2023.
//

import Foundation

/// A selection of **add** or **remove** action to perform on
/// persisted array of `Bookmarks`.
enum PersistenceActionType {

    case add, remove
}

/// An entity that performs CRUD operations on bookmarked users
/// persisted in Documents directory of the device.
enum PersistenceManager {

    /// A collection of file names used in data persistence operations.
    enum Files {

        static let bookmarkedUsers = "bookmarked_users.json"
    }

    /// An array of usernames that are stored as bookmarked users.
    ///
    /// This array is retrieved on app launch in `application(didFinishLaunchingWithOptions)`
    /// method of `AppDelegate` for quick reference on bookmarked state. It gets updated
    /// every time an `add` or `removed` operation is performed on bookmarked users.
    static var allBookmarkedUsers: [String] = []

    /// Updates the persisted array of bookmarked user, either adding new bookmarks
    /// or deleting existing.
    ///
    /// This method also updates ``allBookmarkedUsers`` array of usernames.
    /// - Parameters:
    ///   - bookmark: A user to persist as a bookmark, presented here as `Follower` type.
    ///   - actionType: An action to perform on persisted bookmarks: add new one or
    ///   delete existing.
    ///   - completion: A completion handler returning an error describing any problem that
    ///   occurred when persisting changes to bookmarks, or `nil` if operation was successful.
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

    /// Retrieves and decodes bookmarked users from persistent storage.
    /// - Parameter completion: A completion handler returning a `Result` type
    /// with an array of ``Follower`` objects as bookmarked users in case of success,
    /// or an error describing the problem that occurred during decoding in case of failure.
    static func retrieveBookmarks(completion: @escaping (Result<[Follower], GFPersistenceError>) -> Void) {

        do {
            let bookmarks = try FileManager.default.decodeFromJSON(fileName: Files.bookmarkedUsers, as: [Follower].self)
            completion(.success(bookmarks))
        } catch GFPersistenceError.dataReadError {
            // file doesn't exist, so it's a first read
            completion(.success([]))
        } catch {
            completion(.failure(.dataDecodeError))
        }
    }

    /// Encodes and writes the array of bookmarked users to persistent storage.
    /// - Parameter bookmarks: Array of users to persist as bookmarks.
    /// - Returns: An error if a problem occurred during encoding or writing
    /// to storage, or `nil` if operation was successful.
    static func saveBookmarks(_ bookmarks: [Follower]) -> GFPersistenceError? {

        do {
            try FileManager.default.encodeToJSON(fileName: Files.bookmarkedUsers, data: bookmarks)
            return nil
        } catch GFPersistenceError.dataEncodeError {
            return .dataEncodeError
        } catch {
            return .writeError
        }
    }
}
