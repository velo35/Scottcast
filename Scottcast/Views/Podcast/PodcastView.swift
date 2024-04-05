//
//  PodcastView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import SwiftUI

struct PodcastView: View 
{
    let podcast: Podcast
    
    var body: some View
    {
        VStack {
            AsyncImage(url: podcast.artworkUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            Text(podcast.author)
                .font(.largeTitle.weight(.semibold))
            
            Text(podcast.title)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            List {
                ForEach(podcast.episodes) { episode in
                    EpisodeCellView(episode: episode)
                }
            }
        }
    }
}

#Preview {
    PodcastView(podcast: .mock)
        .environment(PodcastViewModel())
}
