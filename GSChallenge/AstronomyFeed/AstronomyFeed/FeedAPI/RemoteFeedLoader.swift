//
//  RemoteFeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 23/12/24.
//

import Foundation

public typealias HTTPClientResult = Result<(data: Data, response: HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result<[FeedPicture], RemoteFeedLoader.Error>) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200,
                    let picture = try? JSONDecoder().decode(FeedPicture.self, from: data) {
                    completion(.success([picture]))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
