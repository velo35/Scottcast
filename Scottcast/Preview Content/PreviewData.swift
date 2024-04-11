//
//  PreviewData.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation

extension Podcast
{
    static let mock = {
        let pocastPath = Bundle.main.path(forResource: "hh_itunes.json", ofType: nil)!
        let data = (try! String(contentsOfFile: pocastPath)).data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(Podcast.self, from: data)
    }()
}

extension Episode
{
    static let mock = {
        // GRAM 224. Oraciones condicionales con el indicativo
        Podcast.mock.episodes.first(where: { $0.id == 1000651283182})!
    }()
    
    static let mock2 = {
        // LaInfancia
        Podcast.mock.episodes.first(where: { $0.id == 1000651065168})!
    }()
}
