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
    @State private var selected: Podcast?
    
    var body: some View
    {
        ZStack(alignment: .bottom) {
            NavigationStack {
                PodcastGridView(podcasts: podcasts) { podcast in
                    selected = podcast
                }
                .navigationTitle("Scottcast")
                .navigationDestination(item: $selected) { podcast in
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
