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
    let addCallback: (PodcastInfo.ID) -> Void
    @State private var searchText = ""
    @State private var podcastInfos = [PodcastInfo]()
    @State private var selected: PodcastInfo?
    
    func search(term searchTerm: String)
    {
        Task {
            let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=podcast")!
            let data = try await NetworkService.fetch(url: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let search = try decoder.decode(PodcastSearch.self, from: data)
            
            self.podcastInfos = search.podcastInfos
        }
    }
    
    var body: some View
    {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.fixed(160)), .init(.fixed(160))]) {
                    ForEach(podcastInfos) { podcastInfo in
                        VStack {
                            AsyncImage(url: podcastInfo.artworkUrl600) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text(podcastInfo.author)
                        }
                        .onTapGesture {
                            selected = podcastInfo
                        }
                    }
                }
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
                            addCallback(info.id)
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
            guard let term = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
            self.search(term: term)
        }
    }
}

#Preview {
    SearchView() { _ in }
}
