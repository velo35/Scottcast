//
//  PlayPauseButton.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/18/24.
//

import SwiftUI

struct PlayPauseButton: View
{
    let episode: Episode
    
    private var font: Font? = nil
    private let player = PlayerController.shared
    
    init(episode: Episode, size: CGFloat? = nil) {
        self.episode = episode
        if let size {
            font = .system(size: size)
        }
    }
    
    var body: some View
    {
        Button {
            if !player.isPlaying {
                player.play(episode: episode)
            }
            else {
                player.pause()
            }
        } label: {
            Image(systemName: player.isPlaying && player.episode == episode ? "pause.fill" : "play.fill")
                .font(self.font)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PlayPauseButton(episode: .mock, size: 64)
}
