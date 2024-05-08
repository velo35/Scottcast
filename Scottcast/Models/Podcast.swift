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
    
    init(from lookup: PodcastLookup)
    {
        let info = lookup.podcast
        
        self.id = info.id
        self.title = info.title
        self.author = info.author
        self.artworkUrl30 = info.artworkUrl30
        self.artworkUrl60 = info.artworkUrl60
        self.artworkUrl600 = info.artworkUrl600
        self.episodes = lookup.episodes.map{ Episode(from: $0, podcast: self) }
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
