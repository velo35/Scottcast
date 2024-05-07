//
//  SearchView.swift
//  Scottcast
//
//  Created by Scott Daniel on 5/7/24.
//

import SwiftUI

struct SearchView: View 
{
    @State private var searchText = ""
    
    var body: some View
    {
        NavigationStack {
            List {
                Text("hey")
            }            
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) {
            guard let searchTerm = searchText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { print("failed"); return }
            
            Task {
                let url = URL(string: "https://itunes.apple.com/search?term=\(searchTerm)&media=podcast")!
                guard let (data, response) = try await URLSession.shared.data(from: url) as? (Data, HTTPURLResponse),
                      (200 ... 299) ~= response.statusCode else { print("bad response"); return }
                
                let result = String(data: data, encoding: .utf8)!
                print("*****")
                print("\(result)")
            }
        }
    }
}

#Preview {
    SearchView()
}
