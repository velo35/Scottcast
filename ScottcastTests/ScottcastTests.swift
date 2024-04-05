//
//  ScottcastTests.swift
//  ScottcastTests
//
//  Created by Scott Daniel on 4/3/24.
//

import XCTest
@testable import Scottcast

final class ScottcastTests: XCTestCase {
    
    let firstEpisode = Episode(
        id: 1000651283182,
        podcastId: 1201483158,
        title: "GRAM 224. Oraciones condicionales con el indicativo",
        date: ISO8601DateFormatter().date(from: "2024-04-03T08:30:35Z")!,
        description: "En este episodio de gramática y lengua española vamos a practicar con las oraciones condicionales que emplean el modo indicativo, es decir, las oraciones condicionales más realizables. Puedes ver la transcripción de este audio y ejercicios para practicar en: www.hoyhablamos.com",
        durationMillis: 700000,
        url: URL(string: "https://media.blubrry.com/podcast_diario_de_espaol/content.blubrry.com/podcast_diario_de_espaol/Episodio_GRAM_224_Oraciones_condicionales_con_el_indicativo_mezcla.mp3")!
    )

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEpisodeDecode() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let trackPath = Bundle.main.path(forResource: "hh_track.json", ofType: nil)!
        let data = (try String(contentsOfFile: trackPath)).data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let episode = try decoder.decode(Episode.self, from: data)
        
        XCTAssertEqual(episode.id, firstEpisode.id)
        XCTAssertEqual(episode.podcastId, firstEpisode.podcastId)
        XCTAssertEqual(episode.title, firstEpisode.title)
        XCTAssertEqual(episode.date, firstEpisode.date)
        XCTAssertEqual(episode.description, firstEpisode.description)
        XCTAssertEqual(episode.durationMillis, firstEpisode.durationMillis)
        XCTAssertEqual(episode.url, firstEpisode.url)
    }
    
    func testPodcastDecode() throws {
        let pocastPath = Bundle.main.path(forResource: "hh_itunes.json", ofType: nil)!
        let data = (try String(contentsOfFile: pocastPath)).data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let podcast = try decoder.decode(Podcast.self, from: data)
        XCTAssertEqual(podcast.id, 1201483158)
        XCTAssertEqual(podcast.title, "Podcast diario para aprender español - Learn Spanish Daily Podcast")
        XCTAssertEqual(podcast.author, "Hoy Hablamos")
        XCTAssertEqual(podcast.artworkUrl, URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Podcasts125/v4/72/ee/37/72ee370b-3d51-27f2-92a2-37a3a3057391/mza_4998403547888481662.jpg/600x600bb.jpg")!)
        
        let episode = podcast.episodes[0]
        XCTAssertEqual(episode.id, firstEpisode.id)
        XCTAssertEqual(episode.podcastId, firstEpisode.podcastId)
        XCTAssertEqual(episode.title, firstEpisode.title)
        XCTAssertEqual(episode.date, firstEpisode.date)
        XCTAssertEqual(episode.description, firstEpisode.description)
        XCTAssertEqual(episode.durationMillis, firstEpisode.durationMillis)
        XCTAssertEqual(episode.url, firstEpisode.url)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
