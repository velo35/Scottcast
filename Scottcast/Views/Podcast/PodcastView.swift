//
//  PodcastView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import SwiftUI
import SwiftData

struct PodcastView: View 
{
    let podcast: Podcast
    
    var body: some View
    {
        VStack {
            AsyncImage(url: podcast.artworkUrl600) { image in
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
                ForEach(podcast.sortedEpisodes) { episode in
                    EpisodeCellView(episode: episode)
                }
            }
        }
    }
}

#Preview {
    PodcastView(podcast: .mock)
}
