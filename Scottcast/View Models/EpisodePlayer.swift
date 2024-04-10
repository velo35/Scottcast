//
//  EpisodePlayer.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/5/24.
//

import Foundation
import AVFoundation

@Observable
class EpisodePlayer: NSObject
{
    static let shared = EpisodePlayer()
    override private init() {}
    
    private var player: AVPlayer?
    
    var episode: Episode? {
        didSet {
            guard let episode, episode != oldValue, episode.isDownloaded else { return }
            let player = AVPlayer(url: episode.fileUrl)
            player.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
            self.player = player
        }
    }
    
    var rate: Float = 0.0
    
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
