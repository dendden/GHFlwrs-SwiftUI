//
//  FollowerCellView.swift
//  GHFlwrs-SwiftUI
//
//  Created by Денис Трясунов on 30.04.2023.
//

import SwiftUI

struct FollowerCellView: View {

    let cache = NetworkManager.shared.cache
    let follower: Follower

    @State private var avatarImage = Image("avatar-placeholder")

//    init(follower: Follower) {
//        self.follower = follower
//        downloadImage(from: follower.avatarUrl)
//    }

    var body: some View {

        VStack(spacing: 12) {
            avatarImage
                .resizable()
                .cornerRadius(10)
                .aspectRatio(1, contentMode: .fit)

            Text(follower.login)
                .gfTitle(alignment: .center, fontSize: 16)
                .frame(height: 20)
        }
        .padding(8)
        .onAppear {
            downloadImage(from: follower.avatarUrl)
        }
    }

    func downloadImage(from urlString: String) {

        let cacheKey = NSString(string: urlString)

        // check if image is already in cache - so there's no need for download
        if let image = cache.object(forKey: cacheKey) {
            self.avatarImage = Image(uiImage: image)
            return
        }

        guard let url = URL(string: urlString) else { return }

        let networkTask = URLSession.shared.dataTask(with: url) { data, response, error in

            if error != nil { return }

            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200
            else {
                return
            }

            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async {
                self.avatarImage = Image(uiImage: image)
            }
        }

        networkTask.resume()
    }
}

struct FollowerCellView_Previews: PreviewProvider {
    static var previews: some View {
        FollowerCellView(follower: .example)
    }
}
