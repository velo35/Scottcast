//
//  PodcastViewModel.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation
import AVFoundation

@Observable
class PodcastViewModel
{
    private(set) var podcast: Podcast?
    
    var episode: Episode? {
        didSet {
            if oldValue != self.episode {
                self.setupPlayer()
            }
        }
    }
    
    var rate: Float = 0.0
    var elapsed: TimeInterval = 0
    
    private var player: AVPlayer?
    private var observations = [NSKeyValueObservation]()
    
    init()
    {
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

extension PodcastViewModel // Player
{
    var isPlaying: Bool { self.rate != 0.0 }
    
    var duration: TimeInterval { self.player?.currentItem?.duration.seconds ?? 0 }
    
    func setupPlayer()
    {
        guard let episode, episode.isDownloaded else { return }
        let player = AVPlayer(url: episode.fileUrl)
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: 1), queue: nil) { [unowned self] time in
            self.elapsed = time.seconds
        }
        self.observations = [
            player.observe(\.rate, options: .new) { player, change in
                guard let rate = change.newValue else { return }
                self.rate = rate
            }
        ]
        
        self.player = player
    }
    
    func play()
    {
        self.player?.play()
    }
    
    func pause()
    {
        self.player?.pause()
    }
    
    func skip(amount: TimeInterval)
    {
        let seek = self.elapsed + amount
        self.player?.seek(to: CMTime(seconds: seek, preferredTimescale: 1))
    }
}
