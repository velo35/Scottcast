//
//  PlayerController.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation
import AVFoundation
import SwiftData

@Observable
class PlayerController
{
    static let shared = PlayerController()
    
    private init() {}
    
    private(set) var episode: Episode? {
        didSet {
            if oldValue != self.episode {
                self.setupPlayer()
            }
        }
    }
    
    var rate: Float = 0.0
    var elapsed: TimeInterval = 0
    var isPlaying: Bool { self.rate != 0.0 }
    var duration: TimeInterval { self.player?.currentItem?.duration.seconds ?? 0 }
    
    private var player: AVPlayer?
    private var observations = [NSKeyValueObservation]()
    
    func setupPlayer()
    {
        guard let episode else { return }
        let player = AVPlayer(url: episode.isDownloaded ? episode.fileUrl : episode.url)
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
