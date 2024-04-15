//
//  Episode.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation

struct Episode: Identifiable, Equatable
{
    let id: Int
    let podcastId: Int
    let title: String
    let date: Date
    let description: String
    let durationMillis: Int
    let url: URL
    var isDownloaded = false
}

extension Episode
{
    var fileUrl: URL {
        URL.documentsDirectory
            .appending(component: "Pocasts")
            .appending(component: "\(self.podcastId)")
            .appending(component: "Episodes")
            .appending(component: "\(self.id)")
            .appendingPathExtension("mp3")
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
