//
//  EpisodeCellView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import SwiftUI

struct EpisodeCellView: View
{
    @Environment(PodcastViewModel.self) var viewModel
    
    let episode: Episode
    
    var downloadButton: some View
    {
        Button {
            Task {
                do {
                    try await viewModel.download(episode: episode)
                } catch {
                    print(error.localizedDescription)
                }
            }
        } label: {
            Image(systemName: "arrow.down.circle")
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
    
    var playPauseButton: some View
    {
        Button {
            viewModel.episode = episode
            
            if !viewModel.isPlaying {
                viewModel.play()
            }
            else {
                viewModel.pause()
            }
        } label: {
            Image(systemName: viewModel.isPlaying ? "pause.circle" : "play.circle")
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.title)
            
            HStack {
                if episode.isDownloaded {
                    playPauseButton
                }
                else {
                    downloadButton
                }
                
                if episode.isDownloading {
                    ProgressView(value: episode.downloadProgress)
                }
            }
            .padding(6)
        }
    }
}

#Preview {
    EpisodeCellView(episode: .mock)
        .environment(PodcastViewModel())
}
