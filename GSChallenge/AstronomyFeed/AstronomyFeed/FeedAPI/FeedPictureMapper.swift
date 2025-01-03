//
//  FeedPictureMapper.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 26/12/24.
//

import Foundation

struct RemoteFeedPicture: Decodable {
    let date: String
    let explanation: String
    let title: String
    let url: String
}

final class FeedPictureMapper {
    
    static private var OK_200: Int { return 200 }
        
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RemoteFeedPicture] {
        guard response.statusCode == OK_200,
                let feed = try? JSONDecoder().decode(RemoteFeedPicture.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return [feed]
    }
}
