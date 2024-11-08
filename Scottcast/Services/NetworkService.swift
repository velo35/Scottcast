//
//  NetworkService.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation
import SwiftData

enum NetworkServiceError: Error
{
    case response
}

enum NetworkService
{
    static func fetch(url: URL) async throws -> Data
    {
        guard let (data, response) = try await URLSession.shared.data(from: url) as? (Data, HTTPURLResponse),
              (200 ... 299).contains(response.statusCode) else { throw NetworkServiceError.response }
        return data
    }
    
    static func lookup(podcastId id: Int) async throws -> PodcastLookup
    {
        let url = URL(string: "https://itunes.apple.com/lookup?id=\(id)&media=podcast&entity=podcastEpisode")!
        let data = try await NetworkService.fetch(url: url)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let lookup = try decoder.decode(PodcastLookup.self, from: data)
        return lookup
    }
}
