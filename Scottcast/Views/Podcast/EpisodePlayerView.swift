//
//  EpisodePlayerView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/10/24.
//

import SwiftUI

struct EpisodePlayerView: View 
{
    let episode: Episode
    
    var body: some View
    {
        HStack {            
            VStack {
                Text(episode.title)
                
                Text(episode.description)
            }
            
            Image(systemName: "play.fill")
        }
    }
}

#Preview {
    EpisodePlayerView(episode: .mock)
}
