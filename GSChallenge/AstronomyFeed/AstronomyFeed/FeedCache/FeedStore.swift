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
    func insert(_ pictures: [LocalFeedPicture], completion: @escaping InsertCompletion)
}

public struct LocalFeedPicture: Equatable {
    public let date: String
    public let explanation: String
    public let title: String
    public let url: String
    
    public init(date: String, explanation: String, title: String, url: String) {
        self.date = date
        self.explanation = explanation
        self.title = title
        self.url = url
    }
}

