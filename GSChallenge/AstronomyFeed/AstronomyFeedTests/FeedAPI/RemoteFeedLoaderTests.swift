//
//  AstronomyFeedTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 10/03/24.
//

import XCTest
import AstronomyFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesnotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        let clientError = NSError(domain: "Test", code: 0)

        expect(sut: sut, toCompleteWithResult: failure(.connectivity)) {
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200Response() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut: sut, toCompleteWithResult: failure(.invalidData)) {
                let picture = makePicture()
                let json = makePictureJSON(json: picture.json)
                client.complete(with: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ResponseWithInvalidData() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        let invalidData = Data.init("Invalid JSON".utf8)

        expect(sut: sut, toCompleteWithResult: failure(.invalidData)) {
            client.complete(with: 200, data: invalidData)
        }
    }
    
    func test_load_deliversPicturesOn200ResponseWithValidData() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        let picture = makePicture()
                
        expect(sut: sut, toCompleteWithResult: .success([picture.model])) {
            let data = makePictureJSON(json: picture.json)
            client.complete(with: 200, data: data)
        }
    }
    
    func test_load_doesNotDeliverResultAfterInstanceIsDeallocated() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load {
            capturedResults.append($0)
        }

        sut = nil
        let data = makePictureJSON(json: makePicture().json)
        client.complete(with: 200, data: data)
        
        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(with statusCode: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            let clientResponse = (data: data, response: response)
            messages[index].completion(.success(clientResponse))
        }
    }
    
    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        trackMemoryLeaks(for: sut, file: file, line: line)
        trackMemoryLeaks(for: client, file: file, line: line)
        
        return (sut, client)
    }
        
    private func makePicture() -> (model: FeedPicture, json: [String: Any]) {
        let picture = FeedPicture(
            date: "2024-12-25",
            explanation: "A test explanation",
            title: "Space Star",
            url: "https://a-image-url.com"
        )
        let pictureJSON = [
            "date": picture.date,
            "explanation": picture.explanation,
            "title": picture.title,
            "url": picture.url,
        ]
        return (picture, pictureJSON)
    }
    
    private func makePictureJSON(json: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(sut: RemoteFeedLoader, toCompleteWithResult expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPicture), .success(expectedPicture)):
                XCTAssertEqual(receivedPicture, expectedPicture, file: file, line: line)
                
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
    }
}
