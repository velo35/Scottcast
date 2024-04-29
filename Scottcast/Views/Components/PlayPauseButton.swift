//
//  PlayPauseButton.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/18/24.
//

import SwiftUI

struct PlayPauseButton: View
{
    @Environment(PodcastViewModel.self) var viewModel
    
    let episode: Episode
    var font: Font? = nil
    
    init(episode: Episode, size: CGFloat? = nil) {
        self.episode = episode
        if let size {
            font = .system(size: size)
        }
    }
    
    var body: some View
    {
        Button {
            withAnimation {
                viewModel.episode = episode
            }
            
            if !viewModel.isPlaying {
                viewModel.play()
            }
            else {
                viewModel.pause()
            }
        } label: {
            Image(systemName: viewModel.isPlaying && viewModel.episode == episode ? "pause.fill" : "play.fill")
                .font(self.font)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PlayPauseButton(episode: .mock, size: 64)
        .environment(PodcastViewModel())
}
