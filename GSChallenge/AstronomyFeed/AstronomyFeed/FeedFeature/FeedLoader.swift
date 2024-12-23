//
//  FeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 03/03/24.
//

import Foundation

enum LoadFeedResult {
    case success([FeedPicture])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
