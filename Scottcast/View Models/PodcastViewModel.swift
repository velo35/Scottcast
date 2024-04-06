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
    
    init()
    {
        Task {
            do {
                let url = URL(string: "https://itunes.apple.com/lookup?id=1201483158&media=podcast&entity=podcastEpisode&limit=1")!
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
        
        podcast?[episode.id]?.isDownloading = true
        for await event in download.events {
            switch event {
                case let .progress(totalBytesWritten, totalBytesExpectedToWrite):
                    podcast?[episode.id]?.updateProgress(currentBytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
                case .finished(let url):
                    podcast?[episode.id]?.fileUrl = url
                case .error:
                    print("failed!")
            }
        }
        podcast?[episode.id]?.isDownloading = false
    }
}
