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
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.title)
            
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
                    Image(systemName: episode.audioUrl == nil ? "arrow.down.circle" : "arrow.down.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(episode.audioUrl == nil ? .primary : Color.cyan)
                }
                .buttonStyle(.plain)
                
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
}
