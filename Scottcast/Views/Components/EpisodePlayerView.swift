//
//  EpisodePlayerView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/10/24.
//

import SwiftUI

struct EpisodePlayerView: View 
{
    @Environment(PodcastViewModel.self) var viewModel
    
    let episode: Episode
    
    var body: some View
    {
        HStack {
            AsyncImage(url: viewModel.podcast?.artworkUrl60) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                MovingTextView(text: episode.title)
                
                Text(episode.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            
            Image(systemName: "play.fill")
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
        .frame(height: 44)
    }
}

#Preview {
    EpisodePlayerView(episode: .mock)
        .background {
            Rectangle()
                .stroke(.red, lineWidth: 1)
        }
        .environment(PodcastViewModel())
}
