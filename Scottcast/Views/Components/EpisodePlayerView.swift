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
//                Text(episode.title)
                MovingTextView(text: episode.title)
                    .mask {
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .white, location: 0.75),
                                Gradient.Stop(color: .white.opacity(0), location: 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                
                Text(episode.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
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
