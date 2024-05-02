//
//  ScottcastApp.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/3/24.
//

import SwiftUI
import SwiftData

@main
struct ScottcastApp: App
{
    var body: some Scene
    {
        WindowGroup {
            ContentView()
                .modelContainer(for: Podcast.self)
        }
    }
}
