//
//  AstronomyFeedAPIEndToEndTests.swift
//  AstronomyFeedAPIEndToEndTests
//
//  Created by Sai Pasumarthy on 31/12/24.
//

import XCTest
import AstronomyFeed

final class AstronomyFeedAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETPictureResult_receivedDemoPicture() {
        switch getPictureResult() {
        case let .success(pictureItems)?:
            XCTAssertEqual(pictureItems.count, 1, "Expected 1 astronomy picture but got \(pictureItems.count) instead")

        case let .failure(error)?:
            XCTFail("Expected success but got error \(error) instead")
            
        default:
            XCTFail("Expected success but got no result instead")
        }
    }
    
    private func getPictureResult(file: StaticString = #filePath, line: UInt = #line) -> LoadFeedResult? {
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")!
        let exp = expectation(description: "Wait for load result")
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteFeedLoader(url: url, client: client)
        var receivedResult: LoadFeedResult?
        trackMemoryLeaks(for: client, file: file, line: line)
        trackMemoryLeaks(for: loader, file: file, line: line)
        
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10.0)

        return receivedResult
    }
}
