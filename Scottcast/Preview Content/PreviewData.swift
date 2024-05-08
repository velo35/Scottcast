//
//  PreviewData.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation

extension PodcastLookup
{
    static let mock: PodcastLookup = {
        let pocastPath = Bundle.main.path(forResource: "hh_itunes.json", ofType: nil)!
        let data = (try! String(contentsOfFile: pocastPath)).data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(PodcastLookup.self, from: data)
    }()
}

extension EpisodeInfo
{
    static let mock = {
        // GRAM 224. Oraciones condicionales con el indicativo
        PodcastLookup.mock.episodes.first(where: { $0.id == 1000651283182})!
    }()
    
    static let mock2 = {
        // LaInfancia
        PodcastLookup.mock.episodes.first(where: { $0.id == 1000651065168})!
    }()
}

extension Podcast
{
    static let mock = {
        Podcast(from: PodcastLookup.mock.podcast, episodes: PodcastLookup.mock.episodes)
    }()
}

extension Episode
{
    static let mock = {
        Episode(from: .mock, podcast: .mock)
    }()
}
