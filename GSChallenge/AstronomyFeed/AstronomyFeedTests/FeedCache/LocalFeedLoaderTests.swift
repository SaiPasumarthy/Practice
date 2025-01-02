//
//  LocalFeedLoaderTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 02/01/25.
//

import XCTest
import AstronomyFeed

class LocalFeedLoader {
    private let store: FeedStore
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ pictures: [FeedPicture]) {
        store.deleteCachedFeed()
    }
}
class FeedStore {
    var deleteCacheCallCount = 0
    var insertCacheCallCount = 0
    
    func deleteCachedFeed() {
        deleteCacheCallCount += 1
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
    }
}
class LocalFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotDeleteCachedFeedUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCacheCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()

        sut.save([uniqueItem()])
                
        XCTAssertEqual(store.deleteCacheCallCount, 1)
    }

    func test_save_doesNotRequestInsertCacheOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save([uniqueItem()])
        
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCacheCallCount, 0)
    }

    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeaks(for: store)
        trackMemoryLeaks(for: sut)
        
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedPicture {
        FeedPicture(
            date: "12-21-2024",
            explanation: "a explanation",
            title: "a title",
            url: "http://www.a-url.com"
        )
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
