//
//  ContentView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View 
{
    @Environment(\.modelContext) var modelContext
    @Query var podcasts: [Podcast]
    
    private var viewModel = PodcastViewModel()
    
    var body: some View
    {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if let podcast = podcasts.first {
                    PodcastView(podcast: podcast)                    
                }
                
                if let episode = viewModel.episode {
                    EpisodePlayerView(episode: episode)
                        .transition(.move(edge: .bottom))
                }
            }
            .navigationTitle("Scottcast")
        }
        .task {
            do {
                let url = URL(string: "https://itunes.apple.com/lookup?id=1201483158&media=podcast&entity=podcastEpisode")!
                let data = try await NetworkService.fetch(url: url)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let info = try decoder.decode(PodcastInfo.self, from: data)
                let podcast = Podcast(from: info)
                
                modelContext.insert(podcast)
            } catch {
                print(error.localizedDescription)
            }
        }
        .environment(viewModel)
    }
}

#Preview {
    ContentView()
        .environment(PodcastViewModel())
}
