//
//  PodcastViewModel.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation
import AVFoundation

@Observable
class PodcastViewModel: NSObject
{
    private(set) var podcast: Podcast?
    
    var episode: Episode? {
        didSet {
            guard let episode, episode != oldValue, episode.isDownloaded else { return }
            let player = AVPlayer(url: episode.fileUrl)
            player.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
            self.player = player
        }
    }
    
    var rate: Float = 0.0
    
    private var player: AVPlayer?
    
    override init()
    {
        super.init()
        
        if let data = try? Data(contentsOf: podcastUrl) {
            do {
                self.podcast = try Podcast.deserialize(data: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        else {
            Task {
                do {
                    let url = URL(string: "https://itunes.apple.com/lookup?id=1201483158&media=podcast&entity=podcastEpisode")!
                    let data = try await NetworkService.fetch(url: url)
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    self.podcast = try decoder.decode(Podcast.self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func download(episode: Episode) -> DownloadViewModel
    {
        let vm = DownloadViewModel(episode: episode)
        let _ = withObservationTracking {
            vm.succeeded
        } onChange: {
            DispatchQueue.main.async {
                if vm.succeeded {
                    self.podcast?[episode.id]?.isDownloaded = true
                }
                
                if let podcast = self.podcast {
                    do {
                        let serialized = try podcast.serialize()
                        try serialized.write(to: self.podcastUrl, options: .atomic)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        return vm
    }
}

extension PodcastViewModel
{
    var podcastUrl: URL
    {
        URL.documentsDirectory
            .appending(component: "podcast")
            .appendingPathExtension("plist")
    }
}

extension PodcastViewModel
{
    var isPlaying: Bool { self.rate != 0.0 }
    
    func play()
    {
        self.player?.play()
    }
    
    func pause()
    {
        self.player?.pause()
    }
    
    @objc
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "rate", let rate = change?[.newKey] as? Float {
            self.rate = rate
        }
    }
}
