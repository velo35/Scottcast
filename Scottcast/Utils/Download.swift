//
//  EpisodeDownload.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation

class Download: NSObject
{
    enum Event
    {
        case progress(Int64, Int64)
        case finished
        case error
    }
    
    private static let downloader = URLSession(configuration: .default)
    
    private let episode: Episode
    private var continuation: AsyncStream<Event>.Continuation?
    
    private lazy var task = {
        let task = Self.downloader.downloadTask(with: self.episode.url)
        task.delegate = self
        return task
    }()
    
    init(episode: Episode)
    {
        self.episode = episode
    }
    
    var events: AsyncStream<Event>
    {
        AsyncStream { continuation in
            self.continuation = continuation
            self.task.resume()
//            continuation.onTermination = { @Sendable _
//                
//            }
        }
    }
}

extension Download: URLSessionDownloadDelegate
{
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) 
    {
        do {
            let fileManager = FileManager.default
            let episodesDirectory = episode.fileUrl.deletingLastPathComponent()
            if !fileManager.fileExists(atPath: episodesDirectory.path()) {
                try fileManager.createDirectory(at: episodesDirectory, withIntermediateDirectories: true)
            }
            try fileManager.moveItem(at: location, to: episode.fileUrl)
            self.continuation?.yield(.finished)
        } catch {
            print("finished error: \(error.localizedDescription)")
            self.continuation?.yield(.error)
        }
        self.continuation?.finish()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        self.continuation?.yield(.progress(totalBytesWritten, totalBytesExpectedToWrite))
    }
}
