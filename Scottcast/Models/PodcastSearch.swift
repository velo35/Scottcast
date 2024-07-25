//
//  PodcastSearch.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/8/24.
//

import Foundation

struct PodcastSearch
{
    let podcastInfos: [PodcastInfo]
}

extension PodcastSearch: Decodable
{
    enum ContainerKeys: CodingKey
    {
        case results
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        
        var podcastInfos = [PodcastInfo]()
        while !resultsContainer.isAtEnd {
            podcastInfos.append(try resultsContainer.decode(PodcastInfo.self))
        }
        self.podcastInfos = podcastInfos
    }
}
