//
//  FullPlayerView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/29/24.
//

import SwiftUI

struct FullPlayerView: View 
{
    let episode: Episode
    
    @State private var dragging = false
    @State private var elapsed = TimeInterval.zero
    @State private var wasPlaying = false
    private let player = PlayerController.shared
    
    private var elapsedTime: TimeInterval
    {
        dragging ? elapsed : player.elapsed
    }
    
    var body: some View
    {
        VStack {
            AsyncImage(url: episode.podcast!.artworkUrl60) { image in
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
                ProgressView(value: elapsedTime, total: player.duration)
                    .scaleEffect(x: dragging ? 1.05 : 1, y: dragging ? 2.2 : 1)
                    .animation(.default, value: dragging)
                
                HStack {
                    Text(.seconds(elapsedTime), format: .time(pattern: .minuteSecond))
                    
                    Spacer()
                    
                    if player.isLoading {
                        ProgressView()
                    }
                    else {
                        Text("-") + Text(.seconds(player.duration - elapsedTime), format: .time(pattern: .minuteSecond))
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { drag in
                        if !dragging {
                            wasPlaying = player.isPlaying
                            player.pause()
                        }
                        dragging = true
                        elapsed = player.elapsed + player.duration * drag.translation.width / UIScreen.main.bounds.width
                    }
                    .onEnded { drag in
                        player.seek(to: elapsed)
                        if wasPlaying {
                            player.play(episode: episode)
                        }
                        dragging = false
                    }
            )
            
            Spacer().frame(height: 30)
            
            HStack(spacing: 30) {
                Button {
                    player.skip(amount: -15)
                } label: {
                    Image(systemName: "gobackward.15")
                        .font(.system(size: 32))
                }
                .buttonStyle(.plain)
                
                PlayPauseButton(episode: episode, size: 32)
                
                Button {
                    player.skip(amount: 30)
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
    FullPlayerView(episode: .mock)
}
