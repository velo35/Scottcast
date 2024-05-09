//
//  EpisodeCellView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import SwiftUI

struct EpisodeCellView: View
{
    let episode: Episode
    
    @State private var downloadViewModel: DownloadViewModel?
    
    var downloadButton: some View
    {
        Button {
            downloadViewModel = DownloadViewModel(episode: self.episode)
            Task {
                await downloadViewModel?.download()
                downloadViewModel = nil
            }
        } label: {
            Image(systemName: episode.isDownloaded ? "arrow.down.circle.fill" : "arrow.down.circle")
                .imageScale(.large)
                .foregroundStyle(episode.isDownloaded ? .green : .cyan)
                .overlay {
                    if let downloadViewModel {
                        Image(systemName: "arrow.down.circle")
                            .foregroundStyle(.purple)
                            .mask {
                                GeometryReader { proxy in
                                    var path = Path()
                                    let center = CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
                                    let progress = downloadViewModel.progress
                                    path.move(to: center)
                                    path.addArc(center: center, radius: center.x, startAngle: .degrees(0), endAngle: .degrees(360 * progress), clockwise: false)
                                    return path
                                }
                                .rotationEffect(.degrees(-90))
                            }
                    }
                }
        }
        .buttonStyle(.plain)
        .disabled(episode.isDownloaded)
    }
    
    var body: some View
    {
        VStack(alignment: .leading, spacing: 4) {
            Text(episode.dateSinceNow)
                .font(.subheadline)
            
            Text(episode.title)
            
            HStack {
                PlayPauseButton(episode: episode)
                
                if let millis = episode.durationMillis {
                    Text(.milliseconds(millis), format: .time(pattern: .minuteSecond))
                }
                
                Spacer()
                
                downloadButton
            }
        }
    }
}

#Preview {
    EpisodeCellView(episode: .mock)
}
