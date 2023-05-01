//
//  FollowerCellViewModel.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 01.05.2023.
//

import SwiftUI

extension FollowerCellView {
    @MainActor class ViewModel: ObservableObject {

        let cache = NetworkManager.shared.cache

        let follower: Follower

        @Published var avatarImage = Image("avatar-placeholder")

        init(follower: Follower) {
            self.follower = follower
            downloadImage(from: follower.avatarUrl)
        }

        private func downloadImage(from urlString: String) {

            // check if image is already in cache - so there's no need for download
            if let image = cache.object(forKey: NSString(string: urlString)) {
                self.avatarImage = Image(uiImage: image)
                return
            }

            guard let url = URL(string: urlString) else { return }

            let networkTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in

                guard let self = self else { return }

                if error != nil { return }

                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200
                else {
                    return
                }

                guard let data = data else { return }

                guard let image = UIImage(data: data) else { return }
                NetworkManager.shared.cache.setObject(image, forKey: NSString(string: urlString))

                DispatchQueue.main.async {
                    self.avatarImage = Image(uiImage: image)
                }
            }

            networkTask.resume()
        }
    }
}
