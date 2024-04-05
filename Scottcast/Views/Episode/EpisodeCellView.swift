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
    @Environment(EpisodePlayer.self) var episodePlayer
    
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
            if episodePlayer.episode != episode {
                episodePlayer.episode = episode
            }
            
            if !episodePlayer.isPlaying {
                episodePlayer.play()
            }
            else {
                episodePlayer.pause()
            }
        } label: {
            Image(systemName: episodePlayer.isPlaying ? "pause.circle" : "play.circle")
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.title)
            
            HStack {
                if episode.fileUrl == nil {
                    downloadButton
                }
                else {
                    playPauseButton
                }
                
                if episode.isDownloading {
                    ProgressView(value: episode.downloadProgress)
                }
                else {
//                    Spacer()
                }
            }
            .padding(6)
        }
    }
}

#Preview {
    EpisodeCellView(episode: .mock)
        .environment(PodcastViewModel())
        .environment(EpisodePlayer())
}
