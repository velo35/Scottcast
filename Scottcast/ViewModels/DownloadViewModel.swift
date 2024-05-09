//
//  DownloadViewModel.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/15/24.
//

import Foundation

@Observable
class DownloadViewModel
{
    let episode: Episode
    
    var currentBytes: Int64 = 0
    var totalBytes: Int64 = 0
    var succeeded = false
    
    enum Status
    {
        case initial, downloading, success, failed
    }
    
    var status = Status.initial
    
    var progress: Double {
        self.totalBytes > 0 ? Double(self.currentBytes) / Double(self.totalBytes) : 0.0
    }
    
    init(episode: Episode)
    {
        self.episode = episode
    }
    
    @MainActor
    func download() async
    {
        let download = Download(episode: self.episode)
        
        self.status = .downloading
        for await event in download.events {
            switch event {
                case let .progress(totalBytesWritten, totalBytesExpectedToWrite):
                    self.updateProgress(currentBytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
                case .finished:
                    self.episode.isDownloaded = true
                    self.status = .success
                case .error:
                    self.status = .failed
            }
        }
    }
    
    private func updateProgress(currentBytes: Int64, totalBytes: Int64)
    {
        self.currentBytes = currentBytes
        self.totalBytes = totalBytes
    }
}
