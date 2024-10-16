//
//  SearchViewModel.swift
//  Scottcast
//
//  Created by Scott Daniel on 10/15/24.
//

import Foundation

@Observable
class SearchViewModel
{
    private(set) var podcastInfos = [PodcastInfo]()
    private(set) var images = [PodcastInfo.ID: Data]()
    private(set) var isLoading = false
    private var task: Task<Void, Never>?
    
    func search(term searchTerm: String)
    {
        self.task?.cancel()
        
        self.isLoading = true
        self.task = Task {
            do {
                let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=podcast")!
                let data = try await NetworkService.fetch(url: url)
                
                try Task.checkCancellation()
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let search = try decoder.decode(PodcastSearch.self, from: data)
                let podcastInfos = search.podcastInfos
                
                self.podcastInfos = podcastInfos
                
                let images = try await withThrowingTaskGroup(of: (PodcastInfo.ID, Data).self) { group in
                    try Task.checkCancellation()
                    
                    for info in podcastInfos {
                        guard self.images[info.id] == nil else { continue }
                        group.addTask {
                            let data = try await NetworkService.fetch(url: info.artworkUrl600)
                            return (info.id, data)
                        }
                    }
                    
                    var images = [PodcastInfo.ID: Data]()
                    for try await (id, data) in group {
                        images[id] = data
                    }
                    return images
                }
                
                for (id, data) in images {
                    self.images[id] = data
                }
            }
            catch {
                print(error.localizedDescription)
            }
            isLoading = false
        }
    }
}
