//
//  EpisodePlayer.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/5/24.
//

import Foundation
import AVFAudio

enum EpisodePlayerError: Error
{
    case play
}

@Observable
class EpisodePlayer
{
    private var player: AVAudioPlayer?
    
    var episode: Episode?
    var isActive = false
    
    func play() throws
    {
        guard let url = self.episode?.fileUrl else { throw EpisodePlayerError.play }
        self.player = try AVAudioPlayer(contentsOf: url)
        self.player?.play()
    }
    
    func stop()
    {
        self.player?.stop()
    }
}
