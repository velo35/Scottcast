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
    var fileUrl: URL?
    var isDownloading = false
    var currentBytes: Int64 = 0
    var totalBytes: Int64 = 0
    
    var downloadProgress: Double {
        self.totalBytes > 0 ? Double(self.currentBytes) / Double(self.totalBytes) : 0.0
    }    
    
    mutating func updateProgress(currentBytes: Int64, totalBytes: Int64)
    {
        self.currentBytes = currentBytes
        self.totalBytes = totalBytes
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
