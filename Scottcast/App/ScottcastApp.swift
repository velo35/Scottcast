//
//  ScottcastApp.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI

@main
struct ScottcastApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PodcastViewModel())
                .environment(EpisodePlayer())
        }
    }
}
