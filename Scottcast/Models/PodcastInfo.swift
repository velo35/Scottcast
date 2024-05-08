//
//  PodcastInfo.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/8/24.
//

import Foundation

struct PodcastInfo: Identifiable, PodcastData
{
    let id: Int
    let title: String
    let author: String
    let artworkUrl30: URL
    let artworkUrl60: URL
    let artworkUrl600: URL
}

extension PodcastInfo: Decodable
{
    enum CodingKeys: String, CodingKey
    {
        case id = "collectionId"
        case title = "collectionName"
        case author = "artistName"
        case artworkUrl30 = "artworkUrl30"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl600 = "artworkUrl600"
    }
}
