//
//  Podcast.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import Foundation

struct Podcast: Identifiable
{
    let id: Int
    let title: String
    let author: String
    let artworkUrl: URL
    var episodes: [Episode]
    
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

extension Podcast: Decodable
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
        case artworkUrl = "artworkUrl600"
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        let podcastContainer = try resultsContainer.nestedContainer(keyedBy: PodcastKeys.self)
        
        self.id = try podcastContainer.decode(Int.self, forKey: .id)
        self.title = try podcastContainer.decode(String.self, forKey: .title)
        self.author = try podcastContainer.decode(String.self, forKey: .author)
        self.artworkUrl = try podcastContainer.decode(URL.self, forKey: .artworkUrl)
        
        var episodes = [Episode]()
        while !resultsContainer.isAtEnd {
            episodes.append(try resultsContainer.decode(Episode.self))
        }
        self.episodes = episodes
    }
}

extension Podcast
{
    func serialize() throws -> Data
    {
        var plist = [String: Any]()
        plist["id"] = self.id
        plist["title"] = self.title
        plist["author"] = self.author
        plist["artworkUrl"] = self.artworkUrl.absoluteString
        plist["episodes"] = self.episodes.map {
            var plist = [String: Any]()
            plist["id"] = $0.id
            plist["podcastId"] = $0.podcastId
            plist["title"] = $0.title
            plist["date"] = $0.date
            plist["description"] = $0.description
            plist["durationMillis"] = $0.durationMillis
            plist["url"] = $0.url.absoluteString
            plist["fileUrl"] = $0.fileUrl?.absoluteString ?? ""
            plist["isDownloading"] = $0.isDownloading
            plist["currentBytes"] = $0.currentBytes
            plist["totalBytes"] = $0.totalBytes
            return plist
        }
        
        return try PropertyListSerialization.data(fromPropertyList: plist, format: .xml, options: .zero)
    }
    
    enum DeserializationError: Error
    {
        case plist
    }
    
    static func deserialize(data: Data) throws -> Podcast
    {
        guard let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let id = plist["id"] as? Int,
              let title = plist["title"] as? String,
              let author = plist["author"] as? String,
              let artwork = plist["artworkUrl"] as? String,
              let artworkUrl = URL(string: artwork),
              let episodesList = plist["episodes"] as? [[String: Any]]
        else { throw DeserializationError.plist }
        let episodes = episodesList.compactMap{ plist -> Episode? in
            guard let id = plist["id"] as? Int,
                  let podcastId = plist["podcastId"] as? Int,
                  let title = plist["title"] as? String,
                  let date = plist["date"] as? Date,
                  let description = plist["description"] as? String,
                  let durationMillis = plist["durationMillis"] as? Int,
                  let urlStr = plist["url"] as? String,
                  let url = URL(string: urlStr),
                  let fileStr = plist["fileUrl"] as? String,
                  let isDownloading = plist["isDownloading"] as? Bool,
                  let currentBytes = plist["currentBytes"] as? Int64,
                  let totalBytes = plist["totalBytes"] as? Int64
            else { return nil }
            let fileUrl = URL(string: fileStr)
            return Episode(
                id: id,
                podcastId: podcastId,
                title: title,
                date: date,
                description: description,
                durationMillis: durationMillis,
                url: url,
                fileUrl: fileUrl,
                isDownloading: isDownloading,
                currentBytes: currentBytes,
                totalBytes: totalBytes
            )
        }
        return Podcast(id: id, title: title, author: author, artworkUrl: artworkUrl, episodes: episodes)
    }
}
