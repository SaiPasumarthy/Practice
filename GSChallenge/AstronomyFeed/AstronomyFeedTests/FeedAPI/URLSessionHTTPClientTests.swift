//
//  URLSessionHTTPClientTests.swift
//  AstronomyFeedTests
//
//  Created by Sai Pasumarthy on 26/12/24.
//

import XCTest
import AstronomyFeed

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: URLRequest(url: url)) { _, _, error in
            if let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_failsOnRequestError() {
        let url = URL(string: "https://any-url.com")!
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.startIntercepting()
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        let exp = expectation(description: "Wait for load to complete")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
                
            default:
                XCTFail("Expected failure error \(error) but got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopIntercepting()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = URL(string: "https://any-url.com")!
        let exp = expectation(description: "Wait for load to complete")

        URLProtocolStub.startIntercepting()
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            exp.fulfill()
        }
        
        let sut = URLSessionHTTPClient()
        
        sut.get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
        URLProtocolStub.stopIntercepting()
    }
    
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(completion: @escaping (URLRequest) -> Void) {
            requestObserver = completion
        }
        
        static func startIntercepting() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopIntercepting() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            requestObserver?(request)
            return request
        }
        
        override func startLoading() {
            guard let stub = URLProtocolStub.stub else {
                return
            }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
