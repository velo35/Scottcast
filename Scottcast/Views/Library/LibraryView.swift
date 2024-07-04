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
    @Environment(\.modelContext) private var modelContext
    @Query private var podcasts: [Podcast]
    @State private var selected: Podcast?
    private let player = PlayerController.shared
    
    var body: some View
    {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [.init(.fixed(160)), .init(.fixed(160))]) {
                        ForEach(podcasts) { podcast in
                            VStack {
                                AsyncImage(url: podcast.artworkUrl600) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                Text(podcast.author)
                            }
                            .onTapGesture {
                                selected = podcast
                            }
                        }
                    }
                }
                .refreshable {
                    do {
                        for podcast in podcasts {
                            let podcast = try await NetworkService.fetch(podcastId: podcast.id)
                            modelContext.insert(podcast)
                            for episode in podcast.episodes {
                                episode.podcast = podcast
                            }                            
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                .navigationTitle("Library")
                .navigationDestination(item: $selected) { podcast in
                    PodcastView(podcast: podcast)
                }
            }
            
            if let episode = player.episode {
                EpisodePlayerView(episode: episode)
                    .transition(.move(edge: .bottom))
            }
        }
//        .task {
//            do {
//                let url = URL(string: "https://itunes.apple.com/lookup?id=1201483158&media=podcast&entity=podcastEpisode")!
//                let data = try await NetworkService.fetch(url: url)
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                let info = try decoder.decode(PodcastInfo.self, from: data)
//                let podcast = Podcast(from: info)
//                
//                modelContext.insert(podcast)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
}

#Preview {
    LibraryView()
}
