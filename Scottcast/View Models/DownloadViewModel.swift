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
    
    var isDownloading = false
    var currentBytes: Int64 = 0
    var totalBytes: Int64 = 0
    var succeeded = false
    
    var downloadProgress: Double {
        self.totalBytes > 0 ? Double(self.currentBytes) / Double(self.totalBytes) : 0.0
    }
    
    func updateProgress(currentBytes: Int64, totalBytes: Int64)
    {
        self.currentBytes = currentBytes
        self.totalBytes = totalBytes
    }
    
    init(episode: Episode)
    {
        self.episode = episode
    }
    
    @MainActor
    func begin() async
    {
        let download = Download(episode: self.episode)
        
        self.isDownloading = true
        for await event in download.events {
            switch event {
                case let .progress(totalBytesWritten, totalBytesExpectedToWrite):
                    self.updateProgress(currentBytes: totalBytesWritten, totalBytes: totalBytesExpectedToWrite)
                case .finished:
                    self.succeeded = true
                case .error:
                    print("failed!")
            }
        }
        self.isDownloading = false
    }
}
