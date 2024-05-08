//
//  PodcastLookup.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/8/24.
//

import Foundation

struct PodcastLookup
{
    let podcast: PodcastInfo
    let episodes: [EpisodeInfo]
}

extension PodcastLookup: Decodable
{
    enum ContainerKeys: String, CodingKey
    {
        case results
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)

        self.podcast = try resultsContainer.decode(PodcastInfo.self)
        
        var episodes = [EpisodeInfo]()
        while !resultsContainer.isAtEnd {
            episodes.append(try resultsContainer.decode(EpisodeInfo.self))
        }
        self.episodes = episodes
    }
}
