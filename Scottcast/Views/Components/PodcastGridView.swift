//
//  PodcastGridView.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/8/24.
//

import SwiftUI

struct PodcastGridView<T: PodcastData>: View
{
    let podcasts: [T]
    let tappedCallback: (T) -> Void
    
    private let columns: [GridItem] = [.init(.fixed(160)), .init(.fixed(160))]
    
    var body: some View
    {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(podcasts) { podcast in
                    VStack {
                        AsyncImage(url: podcast.artworkUrl600) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(podcast.author)
                    }
                    .onTapGesture {
                        tappedCallback(podcast)
                    }
                }
            }
        }
    }
}

#Preview {
    PodcastGridView(podcasts: [Podcast.mock], tappedCallback: { _ in })
}
