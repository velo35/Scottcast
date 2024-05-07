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
    @Environment(\.modelContext) var modelContext
    @Query var podcasts: [Podcast]
    
    private var viewModel = PodcastViewModel()
    
    private let columns: [GridItem] = [.init(.fixed(60)), .init(.fixed(60))]
    
    var body: some View
    {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(podcasts) { podcast in
                            NavigationLink(value: podcast) {
                                AsyncImage(url: podcast.artworkUrl600) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Scottcast")
                .navigationDestination(for: Podcast.self) { podcast in
                    PodcastView(podcast: podcast)
                }
            }
            
            if let episode = viewModel.episode {
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
        .environment(viewModel)
    }
}

#Preview {
    LibraryView()
}
