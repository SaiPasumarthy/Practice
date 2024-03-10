//
//  AstronomyFeedTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 10/03/24.
//

import XCTest
class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
    func get(from url: URL) {
        requestedURL = url
    }
}

final class AstronomyFeedTests: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: URL(string: "https://a-url.com")!, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let loader = RemoteFeedLoader(url: url, client: client)

        loader.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
}
