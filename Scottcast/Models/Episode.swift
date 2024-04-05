//
//  Episode.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation

@Observable
final // <- Decodable - depends on required init or final class?
class Episode: Identifiable
{
    let id: Int
    let podcastId: Int
    let title: String
    let date: Date
    let description: String
    let durationMillis: Int
    let url: URL
    var fileUrl: URL?
    
    var isDownloading = false
    var downloadProgress = 0.0
    
    init(id: Int, podcastId: Int, title: String, date: Date, description: String, durationMillis: Int, url: URL) {
        self.id = id
        self.podcastId = podcastId
        self.title = title
        self.date = date
        self.description = description
        self.durationMillis = durationMillis
        self.url = url
    }
}

extension Episode: Equatable
{
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }
}

extension Episode: Decodable
{
    enum CodingKeys: String, CodingKey
    {
        case id = "trackId"
        case podcastId = "collectionId"
        case title = "trackName"
        case date = "releaseDate"
        case description
        case durationMillis = "trackTimeMillis"
        case url = "episodeUrl"
    }
}
