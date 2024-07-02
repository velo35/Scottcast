//
//  SearchView.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/7/24.
//

import SwiftUI

@MainActor
struct SearchView: View
{
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var podcastInfos = [PodcastInfo]()
    @State private var selected: PodcastInfo?
    
    var body: some View
    {
        NavigationStack {
            PodcastGridView(podcasts: podcastInfos) { info in
                selected = info
            }
            .overlay {
                if let info = selected {
                    VStack {
                        AsyncImage(url: info.artworkUrl600) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height: 200)
                        
                        Text(info.title)
                        
                        Button("Add to Library") {
                            Task {
                                do {
                                    let podcast = try await NetworkService.fetch(podcastId: info.id)
                                    modelContext.insert(podcast)
                                    for episode in podcast.episodes {
                                        episode.podcast = podcast
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            selected = nil
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background {
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .onTapGesture {
                        selected = nil
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) {
            guard let searchTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { print("failed"); return }
            
            Task {
                let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=podcast")!
                let data = try await NetworkService.fetch(url: url)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let search = try decoder.decode(PodcastSearch.self, from: data)
                
                self.podcastInfos = search.podcasts
            }
        }
    }
}

#Preview {
    SearchView()
}
