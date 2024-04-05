//
//  NetworkService.swift
//  Scottcast
//
//  Created by Scott Daniel on 4/4/24.
//

import Foundation

enum NetworkServiceError: Error
{
    case response
}

enum NetworkService
{
    static func fetch(url: URL) async throws -> Data
    {
        guard let (data, response) = try await URLSession.shared.data(from: url) as? (Data, HTTPURLResponse),
              (200 ... 299).contains(response.statusCode) else { throw NetworkServiceError.response }
        return data
    }
}
