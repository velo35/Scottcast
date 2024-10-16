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
    @State private var selected: PodcastInfo?
    private let viewModel = SearchViewModel()
    
    var body: some View
    {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [.init(.fixed(160)), .init(.fixed(160))], spacing: 20) {
                    ForEach(viewModel.podcastInfos) { podcastInfo in
                        VStack {
                            Group {
                                if let data = viewModel.images[podcastInfo.id] {
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
                else if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) {
            guard let term = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
            viewModel.search(term: term)
        }
    }
}

#Preview {
    SearchView() { _ in }
}
