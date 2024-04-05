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
        let trackPath = Bundle.main.path(forResource: "hh_track.json", ofType: nil)!
        let data = (try! String(contentsOfFile: trackPath)).data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(Episode.self, from: data)
    }()
}
