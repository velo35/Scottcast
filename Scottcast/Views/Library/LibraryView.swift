//
//  LibraryView.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/7/24.
//

import SwiftUI
import SwiftData

struct LibraryView: View 
{
    @Binding var selectedPodcast: Podcast?
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .default) private var podcasts: [Podcast]
    private let player = PlayerController.shared
    
    var body: some View
    {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [.init(.fixed(160), alignment: .top), .init(.fixed(160), alignment: .top)]) {
                        ForEach(podcasts.sorted(by: { first, second in first.sortedEpisodes[0].date > second.sortedEpisodes[0].date })) { podcast in
                            VStack {
                                Image(uiImage: UIImage(data: try! Data(contentsOf: podcast.thumbnailUrl))!)
                                    .resizable()
                                    .frame(width: 160, height: 160)
                                
                                Text(podcast.author)
                            }
                            .onTapGesture {
                                selectedPodcast = podcast
                            }
                        }
                    }
                }
                .refreshable {
//                    do {
//                        for podcast in podcasts {
//                            let podcast = try await NetworkService.fetch(podcastId: podcast.id)
//                            modelContext.insert(podcast)
//                            for episode in podcast.episodes {
//                                episode.podcast = podcast
//                            }                            
//                        }
//                    } catch {
//                        print(error.localizedDescription)
//                    }
                }
                .navigationTitle("Library")
                .navigationDestination(item: $selectedPodcast) { podcast in
                    PodcastView(podcast: podcast)
                }
            }
            
            if let episode = player.episode {
                EpisodePlayerView(episode: episode)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    LibraryView(selectedPodcast: .constant(nil))
}
