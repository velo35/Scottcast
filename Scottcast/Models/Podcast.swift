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
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl600: URL
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
        plist["artworkUrl30"] = self.artworkUrl30.absoluteString
        plist["artworkUrl60"] = self.artworkUrl60.absoluteString
        plist["artworkUrl600"] = self.artworkUrl600.absoluteString
        plist["episodes"] = self.episodes.map {
            var plist = [String: Any]()
            plist["id"] = $0.id
            plist["podcastId"] = $0.podcastId
            plist["title"] = $0.title
            plist["date"] = $0.date
            plist["description"] = $0.description
            plist["durationMillis"] = $0.durationMillis
            plist["url"] = $0.url.absoluteString
            plist["isDownloaded"] = $0.isDownloaded
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
              let artwork30 = plist["artworkUrl30"] as? String,
              let artwork30Url = URL(string: artwork30),
              let artwork60 = plist["artworkUrl60"] as? String,
              let artwork60Url = URL(string: artwork60),
              let artwork600 = plist["artworkUrl600"] as? String,
              let artwork600Url = URL(string: artwork600),
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
                  let isDownloaded = plist["isDownloaded"] as? Bool,
                  let isDownloading = plist["isDownloading"] as? Bool,
                  let currentBytes = plist["currentBytes"] as? Int64,
                  let totalBytes = plist["totalBytes"] as? Int64
            else { return nil }
            return Episode(
                id: id,
                podcastId: podcastId,
                title: title,
                date: date,
                description: description,
                durationMillis: durationMillis,
                url: url,
                isDownloaded: isDownloaded,
                isDownloading: isDownloading,
                currentBytes: currentBytes,
                totalBytes: totalBytes
            )
        }
        
        return Podcast(
            id: id, 
            title: title,
            author: author,
            artworkUrl30: artwork30Url,
            artworkUrl60: artwork60Url,
            artworkUrl600: artwork600Url,
            episodes: episodes
        )
    }
}
