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
    
    @State private var showFullPlayer = false
    
    var body: some View
    {
        CompactPlayerView(episode: episode)
            .padding(.horizontal)
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
}
