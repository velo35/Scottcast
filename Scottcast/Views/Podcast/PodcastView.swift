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
    @Environment(\.modelContext) private var modelContext
    
    let podcast: Podcast
    
    var body: some View
    {
        List {
            Section {
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
                }
            }
            
            ForEach(podcast.sortedEpisodes) { episode in
                EpisodeCellView(episode: episode)
            }
        }
        .refreshable {
            do {
                let episodes = try await NetworkService.fetch(podcastId: podcast.id)
                for episode in episodes {
                    modelContext.insert(episode)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    PodcastView(podcast: .mock)
}
