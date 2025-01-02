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
        store.deleteCache(pictures: pictures)
    }
}
class FeedStore {
    var deleteCallCount: Int = 0
    
    func deleteCache(pictures: [FeedPicture]) {
        deleteCallCount += 1
    }
}
class LocalFeedLoaderTests: XCTestCase {
    
    func test_init_doNotCallDeleteCallCount() {
        let (store, _) = makeSUT()
        
        XCTAssertEqual(store.deleteCallCount, 0)
    }
    
    func test_save_callDeleteCallCount() {
        let (store, loader) = makeSUT()
        
        loader.save([uniqueItem()])
        XCTAssertEqual(store.deleteCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (store: FeedStore, loader: LocalFeedLoader) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackMemoryLeaks(for: store)
        trackMemoryLeaks(for: sut)
        
        return (store, sut)
    }
    
    private func uniqueItem() -> FeedPicture {
        FeedPicture(
            date: "12-21-2024",
            explanation: "a explanation",
            title: "a title",
            url: "http://www.a-url.com"
        )
    }
}
