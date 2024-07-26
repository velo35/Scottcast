//
//  Podcast.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation
import SwiftData

@Model
final class Podcast: Identifiable
{
    @Attribute(.unique)
    let id: Int
    let title: String
    let author: String
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl600: URL
    @Relationship(deleteRule: .cascade, inverse: \Episode.podcast)
    var episodes: [Episode]
    
    init(id: Int, title: String, author: String, artworkUrl30: URL, artworkUrl60: URL, artworkUrl600: URL, episodes: [Episode])
    {
        self.id = id
        self.title = title
        self.author = author
        self.artworkUrl30 = artworkUrl30
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl600 = artworkUrl600
        self.episodes = episodes
    }
    
    var sortedEpisodes: [Episode]
    {
        self.episodes.sorted(using: KeyPathComparator(\.date, order: .reverse))
    }
}

extension Podcast
{
    convenience init(from info: PodcastInfo, episodes: [Episode])
    {
        self.init(
            id: info.id,
            title: info.title,
            author: info.author,
            artworkUrl30: info.artworkUrl30,
            artworkUrl60: info.artworkUrl60,
            artworkUrl600: info.artworkUrl600,
            episodes: episodes
        )
    }
    
    var thumbnailUrl: URL
    {
        URL.documentsDirectory
            .appending(path: "thumbnails/\(self.id)")
    }
}
