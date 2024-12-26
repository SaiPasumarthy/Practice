//
//  RemoteFeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 23/12/24.
//

import Foundation

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
                do {
                    let feedPicture = try FeedPictureMapper.map(data, response)
                    completion(.success([feedPicture]))
                } catch {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private class FeedPictureMapper {
    private struct RemoteFeedPicture: Decodable {
        private let date: String
        private let explanation: String
        private let title: String
        private let url: String
        
        var picture: FeedPicture {
            FeedPicture(
                date: date,
                explanation: explanation,
                title: title,
                url: url
            )
        }
    }
    
    static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _  response: HTTPURLResponse) throws -> FeedPicture {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(RemoteFeedPicture.self, from: data).picture
    }
}
