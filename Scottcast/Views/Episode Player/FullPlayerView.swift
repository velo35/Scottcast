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
            
            Text(episode.date, format: .dateTime.day().month())
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            MovingTextView(text: episode.title)
            
            VStack {
                ProgressView(value: 0)
                
                HStack {
                    Text(.seconds(viewModel.elapsed), format: .time(pattern: .minuteSecond))
                    
                    Spacer()
                    
                    Text("-") + Text(.seconds(viewModel.duration - viewModel.elapsed), format: .time(pattern: .minuteSecond))
                }
            }
            
            
            Spacer()
                .frame(height: 30)
            
            PlayPauseButton(episode: episode, size: 32)
        }
        .padding(.horizontal)
    }
}

#Preview {
    FullPlayerView(episode: .mock2)
        .environment(PodcastViewModel())
        .background {
            Rectangle()
                .stroke(lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
        }
}
