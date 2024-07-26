//
//  ContentView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View
{
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPodcast: Podcast?
    @State private var selectedTab = 0
    
    private func addPodcast(id podcastId: PodcastInfo.ID)
    {
        Task {
            do {
                let lookup = try await NetworkService.lookup(podcastId: podcastId)
                
                let episodes = lookup.episodes.map { Episode(from: $0) }
                let podcast = Podcast(from: lookup.podcast, episodes: episodes)
                
                let imageData = try await NetworkService.fetch(url: podcast.artworkUrl600)
                try FileManager.default.createDirectory(at: podcast.thumbnailUrl.deletingLastPathComponent(), withIntermediateDirectories: true)
                try imageData.write(to: podcast.thumbnailUrl)
                
                modelContext.insert(podcast)
                for episode in podcast.episodes {
                    episode.podcast = podcast
                }
                
                selectedPodcast = podcast
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View
    {
        TabView(selection: $selectedTab) {
            LibraryView(selectedPodcast: $selectedPodcast)
                .tag(0)
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
            
            SearchView() { id in
                addPodcast(id: id)
            }
            .tag(1)
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
        }
        .onChange(of: selectedPodcast) {
            if selectedPodcast != nil {
                selectedTab = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
