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
            Group {
                if let podcast = viewModel.podcast {
                    PodcastView(podcast: podcast)
                }
            }
            .navigationTitle("Scottcast")
        }
    }
}

#Preview {
    ContentView()
        .environment(PodcastViewModel())
        .environment(EpisodePlayer())
}
