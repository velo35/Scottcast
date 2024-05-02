//
//  Episode.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation
import SwiftData

@Model
class Episode: Identifiable, Equatable
{
    let id: Int
    let podcastId: Int
    let title: String
    let date: Date
    let details: String
    let durationMillis: Int?
    let url: URL
    var isDownloaded = false
    
    let podcast: Podcast
    
    init(from info: EpisodeInfo, podcast: Podcast)
    {
        self.id = info.id
        self.podcastId = info.podcastId
        self.title = info.title
        self.date = info.date
        self.details = info.description
        self.durationMillis = info.durationMillis
        self.url = info.url
        
        self.podcast = podcast
    }
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
    
    var dateSinceNow: String
    {
        let components = Calendar.current.dateComponents([.weekOfYear, .day, .hour], from: self.date, to: .now)
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        else if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 mimnute ago" : "\(minutes) minutes ago"
        }
        
        return "Just now"
    }
}

struct EpisodeInfo
{
    let id: Int
    let podcastId: Int
    let title: String
    let date: Date
    let description: String
    let durationMillis: Int?
    let url: URL
}

extension EpisodeInfo: Decodable
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
