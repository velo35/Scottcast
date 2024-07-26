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
    @State private var imageCache = [PodcastInfo.ID: Data]()
    @State private var isLoading = false
    
    func search(term searchTerm: String)
    {
        Task {
            isLoading = true
            do {
                let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=podcast")!
                let data = try await NetworkService.fetch(url: url)
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let search = try decoder.decode(PodcastSearch.self, from: data)
                let podcastInfos = search.podcastInfos
                
                for info in podcastInfos {
                    guard self.imageCache[info.id] == nil else { continue }
                    let data = try await NetworkService.fetch(url: info.artworkUrl600)
                    self.imageCache[info.id] = data
                }
                
                self.podcastInfos = podcastInfos
            }
            catch {
                debugPrint(error.localizedDescription)
            }
            isLoading = false
        }
    }
    
    var body: some View
    {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.fixed(160)), .init(.fixed(160))], spacing: 20) {
                    ForEach(podcastInfos) { podcastInfo in
                        VStack {
                            Group {
                                if let data = self.imageCache[podcastInfo.id] {
                                    Image(uiImage: UIImage(data: data)!)
                                        .resizable()
                                }
                                else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 160, height: 160)
                            
                            Text(podcastInfo.author)
                            
                            Spacer()
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
                else if isLoading {
                    ProgressView()
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
