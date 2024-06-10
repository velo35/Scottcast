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
    
    private func fetch(_ id: Int)
    {
        Task {
            do {
                let lookup = try await NetworkService.fetch(podcastId: id)
                let podcast = Podcast(from: lookup.podcast)
                self.modelContext.insert(podcast)
                let episodes = lookup.episodes.map{ Episode(from: $0, podcast: podcast)}
                for episode in episodes {
                    self.modelContext.insert(episode)
                }
                podcast.episodes = episodes
            } catch {
                print("SearchView: \(error.localizedDescription)")
            }
            
        }
    }
    
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
            fetch(podcast.id)
        }
    }
}

#Preview {
    PodcastView(podcast: .mock)
}
