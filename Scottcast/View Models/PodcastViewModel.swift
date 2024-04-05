//
//  PodcastViewModel.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation

@Observable
class PodcastViewModel
{
    private(set) var podcast: Podcast?
    private var downloading = [URL: Download]()
    
    @ObservationIgnored
    private lazy var downloader = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    
    init()
    {
        Task {
            do {
                let url = URL(string: "https://itunes.apple.com/lookup?id=1201483158&media=podcast&entity=podcastEpisode&limit=5")!
                let data = try await NetworkService.fetch(url: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                self.podcast = try decoder.decode(Podcast.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func download(episode: Episode) async throws
    {
        let download = Download(episode: episode)
        
        episode.isDownloading = true
        defer {
            episode.isDownloading = false
        }
        for await event in download.events {
            switch event {
                case .progress(let progress):
                    episode.downloadProgress = progress
                case .finished(let location):
                    let fileManager = FileManager.default
//                    let documents = URL.documentsDirectory
//                    let podcasts = documents.appending(component: "Podcasts", directoryHint: .isDirectory)
//                    let podcast = podcasts.appending(path: "\(episode.podcastId)", directoryHint: .isDirectory)
                    if !fileManager.fileExists(atPath: episode.directoryUrl.path()) {
                        try fileManager.createDirectory(at: episode.directoryUrl, withIntermediateDirectories: true)
                    }
//                    let audioUrl = podcast.appending(component: "\(episode.id)").appendingPathExtension("mp3")
                    print("go: \(fileManager.fileExists(atPath: location.path()))")
//                    print("to: \(location)")
                    try fileManager.moveItem(at: location, to: episode.fileUrl)
                case .error:
                    print("failed!")
            }
        }
    }
}
