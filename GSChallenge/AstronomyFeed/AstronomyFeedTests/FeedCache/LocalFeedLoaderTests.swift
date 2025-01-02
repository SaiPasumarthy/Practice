//
//  LocalFeedLoaderTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 02/01/25.
//

import XCTest
class LocalFeedLoader {
    init(store: FeedStore) {
        
    }
}
class FeedStore {
    var deleteCallCount: Int = 0
}
class LocalFeedLoaderTests: XCTestCase {
    
    func test_init_doNotCallDeleteCallCount() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCallCount, 0)
    }
}
