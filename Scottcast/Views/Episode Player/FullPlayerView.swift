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
            
            Spacer().frame(height: 30)
            
            HStack(spacing: 30) {
                Button {
                    viewModel.skip(amount: -15)
                } label: {
                    Image(systemName: "gobackward.15")
                        .font(.system(size: 32))
                }
                .buttonStyle(.plain)
                
                PlayPauseButton(episode: episode, size: 32)
                
                Button {
                    viewModel.skip(amount: 30)
                } label: {
                    Image(systemName: "goforward.30")
                        .font(.system(size: 32))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    FullPlayerView(episode: .mock2)
        .environment(PodcastViewModel())
        .background {
            Rectangle()
                .stroke(lineWidth: 1)
        }
}
