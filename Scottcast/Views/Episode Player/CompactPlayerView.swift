//
//  CompactPlayerView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/29/24.
//

import SwiftUI

struct CompactPlayerView: View 
{
    let episode: Episode
    
    var body: some View
    {
        HStack {
            AsyncImage(url: episode.podcast!.artworkUrl60) { image in
                image
                    .resizable()
            } placeholder: {
                ProgressView()
            }
            .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading) {
                MovingTextView(text: episode.title)
                
                Text(episode.date, format: .dateTime.day().month())
                    .font(.subheadline)
            }
            
            PlayPauseButton(episode: episode)            
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, maxHeight: 44)
    }
}

#Preview {
    CompactPlayerView(episode: .mock)
}
