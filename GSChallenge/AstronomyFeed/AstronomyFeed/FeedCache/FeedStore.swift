//
//  FeedStore.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 03/01/25.
//

import Foundation

public protocol FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void

    func deleteCachedFeed(completion: @escaping DeleteCompletion)
    func insert(_ pictures: [FeedPicture], completion: @escaping InsertCompletion)
}
