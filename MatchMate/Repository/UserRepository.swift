//
//  UserRepository.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUsers() async throws -> [User]
    func updateStatus(uuid: String, status: MatchStatus)
}

final class UserRepository: UserRepositoryProtocol {
    
    private let apiManager: APIServiceProtocol
    private let coreDataManager: CoreDataManager
    
    init(
        apiManager: APIServiceProtocol = APIManager(),
        coreDataManager: CoreDataManager = .shared
    ) {
        self.apiManager = apiManager
        self.coreDataManager = coreDataManager
    }
    func getUsers() async throws -> [User] {
        
        let cachedUsers = coreDataManager.fetchCachedUsers()
        if !cachedUsers.isEmpty {
            print("Loaded from CoreData")
            return cachedUsers
        }
        do {
            let users = try await apiManager.fetchUsers()
            coreDataManager.saveUsers(users)
            coreDataManager.printAllUsers()
            return users
        } catch {
            return cachedUsers
        }
    }
    
    func updateStatus(uuid: String, status: MatchStatus) {
        coreDataManager.updateStatus(uuid: uuid, status: status)
    }
}
