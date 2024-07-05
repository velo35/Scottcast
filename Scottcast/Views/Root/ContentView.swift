//
//  ContentView.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI
import SwiftData

struct ContentView: View 
{
    @State private var selectedPodcast: Podcast?
    @State private var selectedTab = 0
    
    var body: some View
    {
        TabView(selection: $selectedTab) {
            LibraryView(selectedPodcast: $selectedPodcast)
                .tag(0)
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
            
            SearchView(selectedPodcast: $selectedPodcast)
                .tag(1)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .onChange(of: selectedPodcast) {
            if selectedPodcast != nil {
                selectedTab = 0
            }
        }
    }
}

#Preview {
    ContentView()
}
