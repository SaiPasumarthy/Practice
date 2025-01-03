//
//  LocalFeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 03/01/25.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    
    public init(store: FeedStore) {
        self.store = store
    }
    
    public typealias SaveResult = Error?
    
    public func save(_ pictures: [FeedPicture], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let deletionCacheError = error {
                completion(deletionCacheError)
            } else {
                self.cache(pictures, completion: completion)
            }
        }
    }
    
    private func cache(_ pictures: [FeedPicture], completion: @escaping (SaveResult) -> Void) {
        store.insert(pictures.toLocal()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

private extension Array where Element == FeedPicture {
    func toLocal() -> [LocalFeedPicture] {
        map {
            LocalFeedPicture(date: $0.date, explanation: $0.explanation, title: $0.title, url: $0.url)
        }
    }
}
