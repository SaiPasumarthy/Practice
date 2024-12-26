//
//  HTTPClient.swift
//  AstronomyFeed
//
//  Created by Sai Pasumarthy on 26/12/24.
//

import Foundation

public typealias HTTPClientResult = Result<(data: Data, response: HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
