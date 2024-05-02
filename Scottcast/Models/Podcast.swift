//
//  Podcast.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation
import SwiftData

@Model
class Podcast: Identifiable
{
    let id: Int
    let title: String
    let author: String
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl600: URL
    var episodes = [Episode]()
    
    var sortedEpisodes: [Episode]
    {
        self.episodes.sorted(using: KeyPathComparator(\.date, order: .reverse))
    }
    
    init(from info: PodcastInfo)
    {
        self.id = info.id
        self.title = info.title
        self.author = info.author
        self.artworkUrl30 = info.artworkUrl30
        self.artworkUrl60 = info.artworkUrl60
        self.artworkUrl600 = info.artworkUrl600
        self.episodes = info.episodes.map{ Episode(from: $0, podcast: self) }
    }
    
    subscript(episodeId: Episode.ID) -> Episode? {
        get {
            episodes.first{ episodeId == $0.id }
        }
        set {
            guard let newValue, let index = episodes.firstIndex(where: { episodeId == $0.id }) else { return }
            episodes[index] = newValue
        }
    }
}

struct PodcastInfo: Identifiable
{
    let id: Int
    let title: String
    let author: String
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl600: URL
    var episodes: [EpisodeInfo]
}

extension PodcastInfo: Decodable
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
        case artworkUrl30 = "artworkUrl30"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl600 = "artworkUrl600"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        let podcastContainer = try resultsContainer.nestedContainer(keyedBy: PodcastKeys.self)
        
        self.id = try podcastContainer.decode(Int.self, forKey: .id)
        self.title = try podcastContainer.decode(String.self, forKey: .title)
        self.author = try podcastContainer.decode(String.self, forKey: .author)
        self.artworkUrl30 = try podcastContainer.decode(URL.self, forKey: .artworkUrl30)
        self.artworkUrl60 = try podcastContainer.decode(URL.self, forKey: .artworkUrl60)
        self.artworkUrl600 = try podcastContainer.decode(URL.self, forKey: .artworkUrl600)
        
        var episodes = [EpisodeInfo]()
        while !resultsContainer.isAtEnd {
            episodes.append(try resultsContainer.decode(EpisodeInfo.self))
        }
        self.episodes = episodes
    }
}
