//
//  FeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 03/03/24.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedPicture])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
