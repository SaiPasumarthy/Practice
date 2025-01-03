//
//  RemoteFeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 23/12/24.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success((data, response)):
                do {
                    let items = try FeedPictureMapper.map(data, response)
                    completion(.success(items.toModel()))
                } catch {
                    completion(.failure(error))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

private extension Array where Element == RemoteFeedPicture {
    func toModel() -> [FeedPicture] {
        map {
            FeedPicture(
                date: $0.date,
                explanation: $0.explanation,
                title: $0.title,
                url: $0.url
            )
        }
    }
}
