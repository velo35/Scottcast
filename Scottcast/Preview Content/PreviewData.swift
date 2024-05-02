//
//  PreviewData.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation

extension PodcastInfo
{
    static let mock = {
        let pocastPath = Bundle.main.path(forResource: "hh_itunes.json", ofType: nil)!
        let data = (try! String(contentsOfFile: pocastPath)).data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(PodcastInfo.self, from: data)
    }()
}

extension EpisodeInfo
{
    static let mock = {
        // GRAM 224. Oraciones condicionales con el indicativo
        PodcastInfo.mock.episodes.first(where: { $0.id == 1000651283182})!
    }()
    
    static let mock2 = {
        // LaInfancia
        PodcastInfo.mock.episodes.first(where: { $0.id == 1000651065168})!
    }()
}
