//
//  FeedPictureMapper.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 26/12/24.
//

import Foundation

final class FeedPictureMapper {
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
    
    static private var OK_200: Int { return 200 }
    
    static func map(_ data: Data, _  response: HTTPURLResponse) throws -> FeedPicture {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return try JSONDecoder().decode(RemoteFeedPicture.self, from: data).picture
    }
}
