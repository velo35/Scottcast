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
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.title)
            
            Button {
                do {
                    episodePlayer.episode = episode
                    try episodePlayer.play()
                } catch {
                    print(error.localizedDescription)
                }
            } label: {
                Image(systemName: "play.circle")
            }
            .buttonStyle(.plain)
            
            HStack {
                Button {
                    Task {
                        do {
                            try await viewModel.download(episode: episode)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Image(systemName: episode.fileUrl == nil ? "arrow.down.circle" : "arrow.down.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(episode.fileUrl == nil ? .primary : Color.cyan)
                }
                .buttonStyle(.plain)
                .disabled(episode.fileUrl != nil)
                
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
