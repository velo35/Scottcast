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
    @State private var downloadViewModel: DownloadViewModel?
    
    let episode: Episode
    
    var downloadButton: some View
    {
        Button {
            downloadViewModel = viewModel.download(episode: episode)
            Task {
                await downloadViewModel?.begin()
            }
        } label: {
            Image(systemName: "arrow.down.circle")
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
                    PlayPauseButton(episode: episode)
                }
                else {
                    downloadButton
                }
                
                if let downloadViewModel, downloadViewModel.isDownloading {
                    ProgressView(value: downloadViewModel.downloadProgress)
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
