//
//  PodcastSearch.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/8/24.
//

import Foundation

struct PodcastSearch
{
    let podcasts: [PodcastInfo]
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
        
        var podcasts = [PodcastInfo]()
        while !resultsContainer.isAtEnd {
            podcasts.append(try resultsContainer.decode(PodcastInfo.self))
        }
        self.podcasts = podcasts
    }
}
