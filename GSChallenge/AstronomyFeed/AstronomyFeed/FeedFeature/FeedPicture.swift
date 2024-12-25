//
//  FeedPicture.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 03/03/24.
//

import Foundation

public struct FeedPicture: Equatable, Decodable {
    public let date: String
    public let explanation: String
    public let title: String
    public let url: String
    
    public init(date: String, explanation: String, title: String, url: String) {
        self.date = date
        self.explanation = explanation
        self.title = title
        self.url = url
    }
}
