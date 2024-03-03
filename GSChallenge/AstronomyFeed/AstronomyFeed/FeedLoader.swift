//
//  FeedLoader.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 03/03/24.
//

import Foundation

protocol FeedLoader {
    func load(completion: @escaping (Result<[FeedPicture], Error>) -> Void)
}
