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
    @State private var isCompact = true
    
    var body: some View
    {
        let layout = isCompact ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        
        layout {
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
        .padding(.horizontal)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, maxHeight: isCompact ? 44 : .infinity)
        .background(.white)
        .onTapGesture {
            if isCompact {
                withAnimation {
                    isCompact = false
                }
            }
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
