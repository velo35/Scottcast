//
//  EpisodePlayerView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/10/24.
//

import SwiftUI

struct EpisodePlayerView: View 
{
    @Environment(PodcastViewModel.self) var viewModel
    
    let episode: Episode
    @State private var showFullPlayer = false
    
    var body: some View
    {
        CompactPlayerView(episode: episode)
            .background(.white)
            .onTapGesture {
                showFullPlayer = true
            }
            .sheet(isPresented: $showFullPlayer) {
                FullPlayerView(episode: episode)
            }
    }
}

#Preview {
    EpisodePlayerView(episode: .mock)
        .background {
            Rectangle()
                .stroke(.red, lineWidth: 1)
        }
        .environment(PodcastViewModel())
}
