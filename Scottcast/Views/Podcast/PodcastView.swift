//
//  PodcastView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import SwiftUI

struct PodcastView: View 
{
    @Environment(PodcastViewModel.self) var viewModel
    
    var body: some View
    {
        VStack {
            AsyncImage(url: viewModel.podcast?.artworkUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            Text(viewModel.podcast?.author ?? "")
                .font(.largeTitle.weight(.semibold))
            
            Text(viewModel.podcast?.title ?? "")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            List {
                ForEach(viewModel.podcast?.episodes ?? []) { episode in
                    EpisodeCellView(episode: episode)
                }
            }
        }
    }
}

#Preview {
    PodcastView()
        .environment(PodcastViewModel())
}
