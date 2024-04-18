//
//  ContentView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI

struct ContentView: View 
{
    @Environment(PodcastViewModel.self) var viewModel
    
    var body: some View
    {
        NavigationStack {
            ZStack(alignment: .bottom) {
                PodcastView()
                
                if let episode = viewModel.episode {
                    EpisodePlayerView(episode: episode)
                        .transition(.move(edge: .bottom))
                }
            }
            .navigationTitle("Scottcast")
        }
    }
}

#Preview {
    ContentView()
        .environment(PodcastViewModel())
}
