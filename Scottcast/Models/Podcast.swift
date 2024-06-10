//
//  Podcast.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation
import SwiftData

protocol PodcastData: Identifiable, Hashable
{
    var id: Int { get }
    var title: String { get }
    var author: String { get }
    var artworkUrl30: URL { get }
    var artworkUrl60: URL { get }
    var artworkUrl600: URL { get }
}

@Model
final class Podcast: Identifiable, PodcastData
{
    @Attribute(.unique) let id: Int
    let title: String
    let author: String
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl600: URL
    @Relationship(deleteRule: .cascade, inverse: \Episode.podcast) var episodes = [Episode]()
    
    init(id: Int, title: String, author: String, artworkUrl30: URL, artworkUrl60: URL, artworkUrl600: URL)
    {
        self.id = id
        self.title = title
        self.author = author
        self.artworkUrl30 = artworkUrl30
        self.artworkUrl60 = artworkUrl60
        self.artworkUrl600 = artworkUrl600
    }
    
    var sortedEpisodes: [Episode]
    {
        self.episodes.sorted(using: KeyPathComparator(\.date, order: .reverse))
    }
}

extension Podcast
{
    convenience init(from info: PodcastInfo)
    {
        self.init(
            id: info.id,
            title: info.title,
            author: info.author,
            artworkUrl30: info.artworkUrl30,
            artworkUrl60: info.artworkUrl60,
            artworkUrl600: info.artworkUrl600
        )
    }
}
