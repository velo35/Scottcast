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
        case progress(Double)
        case finished(URL)
        case error
    }
    
    private static let downloader = URLSession(configuration: .default)
    
    private let episode: Episode
//    private let task: URLSessionDownloadTask
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
            let tempDirectory = try fileManager.url(
                for: .itemReplacementDirectory,
                in: .userDomainMask,
                appropriateFor: episode.fileUrl,
                create: true
            )
            let tempFile = tempDirectory.appending(component: ProcessInfo().globallyUniqueString)
            try fileManager.moveItem(at: location, to: tempFile)
            print("tmp: \(fileManager.fileExists(atPath: tempFile.path()))")
            self.continuation?.yield(.finished(tempFile))
        } catch {
            print("finished error: \(error.localizedDescription)")
            self.continuation?.yield(.error)
        }
        self.continuation?.finish()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        self.continuation?.yield(.progress(progress))
    }
}

extension Episode
{
    var directoryUrl: URL {
        URL.documentsDirectory
            .appending(component: "\(self.podcastId)")
    }
    
    var fileUrl: URL {
        directoryUrl
            .appending(component: "\(self.id)")
            .appendingPathExtension("mp3")
    }
}
