//
//  FullPlayerView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/29/24.
//

import SwiftUI

struct FullPlayerView: View 
{
    @Environment(PodcastViewModel.self) var viewModel
    
    let episode: Episode
    
    var body: some View
    {
        VStack {
            AsyncImage(url: viewModel.podcast?.artworkUrl60) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                MovingTextView(text: episode.title)
                
                Text(episode.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
            }
            
            PlayPauseButton(episode: episode) 
        }
    }
}

#Preview {
    FullPlayerView(episode: .mock)
}
