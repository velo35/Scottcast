//
//  PodcastView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import SwiftUI
import SwiftData

@MainActor
struct PodcastView: View
{
    @Environment(\.modelContext) private var modelContext
    
    let podcast: Podcast
    
    private func updatePodcast() async
    {
        do {
            let lookup = try await NetworkService.lookup(podcastId: podcast.id)
            let newEpisodeInfos = lookup.episodes.filter{ info in !self.podcast.episodes.contains(where: { $0.id == info.id }) }
            let newEpisodes = newEpisodeInfos.map{ Episode(from: $0) }
            
            newEpisodes.forEach{ self.modelContext.insert($0) }
            withAnimation {
                podcast.episodes.append(contentsOf: newEpisodes)
            }
        } catch {
            debugPrint(error.localizedDescription)
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
                .frame(maxWidth: .infinity)
            }
            
            ForEach(podcast.sortedEpisodes) { episode in
                EpisodeCellView(episode: episode)
            }
        }
        .onAppear {
            Task {
                await self.updatePodcast()
            }
        }
        .refreshable {
            await self.updatePodcast()
        }
    }
}

#Preview {
    PodcastView(podcast: .mock)
}
