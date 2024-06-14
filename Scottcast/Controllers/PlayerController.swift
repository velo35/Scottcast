//
//  PlayerController.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation
import AVFoundation
import Combine

@Observable
class PlayerController
{
    static let shared = PlayerController()
    
    private init() {}
    
    private(set) var episode: Episode? {
        didSet {
            guard let episode = self.episode, episode != oldValue else { return }
            self.setupPlayer(for: episode)
        }
    }
    
    var rate: Float = 0.0
    var isPlaying: Bool { self.rate != 0.0 }
    private(set) var elapsed: TimeInterval = 0
    private(set) var duration: TimeInterval = 0.0
    private(set) var isLoading = false
    
    private var player: AVPlayer?
    private var cancellables = Set<AnyCancellable>()
    
    private func setupPlayer(for episode: Episode)
    {
        let item = AVPlayerItem(url: episode.isDownloaded ? episode.fileUrl : episode.url)
        let player = AVPlayer(playerItem: item)
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: 1), queue: nil) { [unowned self] time in
            self.elapsed = time.seconds
        }
        
        item.publisher(for: \.duration)
            .first(where: { $0 != .indefinite })
            .map { $0.seconds }
            .assign(to: \.duration, on: self)
            .store(in: &self.cancellables)
        
        player.publisher(for: \.rate)
            .receive(on: DispatchQueue.main)
            .assign(to: \.rate, on: self)
            .store(in: &self.cancellables)
        
        
        
        self.player = player
    }
    
    func play(episode: Episode)
    {
        self.episode = episode
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
    
    func seek(to seconds: Double)
    {
        self.player?.seek(to: CMTime(seconds: seconds, preferredTimescale: 1))
    }
}
