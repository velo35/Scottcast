//
//  Podcast.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation

struct Podcast: Identifiable, Decodable
{
    let id: Int
    let title: String
    let author: String
    let artworkUrl: URL
    let episodes: [Episode]
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        let podcastContainer = try resultsContainer.nestedContainer(keyedBy: PodcastKeys.self)
        
        self.id = try podcastContainer.decode(Int.self, forKey: .id)
        self.title = try podcastContainer.decode(String.self, forKey: .title)
        self.author = try podcastContainer.decode(String.self, forKey: .author)
        self.artworkUrl = try podcastContainer.decode(URL.self, forKey: .artworkUrl)
        
        var episodes = [Episode]()
        while !resultsContainer.isAtEnd {
            episodes.append(try resultsContainer.decode(Episode.self))
        }
        self.episodes = episodes
    }
}

extension Podcast
{
    enum ContainerKeys: String, CodingKey
    {
        case results
    }
    
    enum PodcastKeys: String, CodingKey
    {
        case id = "collectionId"
        case title = "collectionName"
        case author = "artistName"
        case artworkUrl = "artworkUrl600"
    }
}
