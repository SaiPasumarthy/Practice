//
//  AstronomyFeedTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 10/03/24.
//

import XCTest
class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class AstronomyFeedTests: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
