//
//  APIManager.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import Foundation

protocol APIServiceProtocol {
    func fetchUsers() async throws -> [User]
}

class APIManager: APIServiceProtocol {

    let urlString = "https://randomuser.me/api/?results=10"

    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(
            UserResponse.self,
            from: data
        )
        return response.results
    }
}
