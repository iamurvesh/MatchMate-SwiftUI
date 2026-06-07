//
//  MatchListViewModel.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import Foundation
import Combine

@MainActor
final class MatchListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: UserRepositoryProtocol
    
    init(
        repository: UserRepositoryProtocol = UserRepository()
    ) {
        self.repository = repository
    }
    
    func fetchUsers() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            users = try await repository.getUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func acceptUser(_ user: User) {
        repository.updateStatus(uuid: user.id,status: .accepted)
        if let index = users.firstIndex(where: {$0.id == user.id}) {
            users[index].status = .accepted
        }
    }

    func declineUser(_ user: User) {
        repository.updateStatus(uuid: user.id, status: .declined)
        if let index = users.firstIndex(where: {$0.id == user.id}) {
            users[index].status = .declined
        }
    }
}
