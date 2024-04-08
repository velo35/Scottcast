//
//  ContentView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI

struct ContentView: View 
{
    var body: some View
    {
        NavigationStack {
            PodcastView()
                .navigationTitle("Scottcast")
        }
    }
}

#Preview {
    ContentView()
        .environment(PodcastViewModel())
}
