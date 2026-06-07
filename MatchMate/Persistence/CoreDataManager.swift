//
//  CoreDataManager.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import CoreData

enum MatchStatus: String, Codable {
    case pending
    case accepted
    case declined
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "MatchMate")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed : \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllUsers() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
        ProfileEntity.fetchRequest()
        
        let deleteRequest =
        NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try container
                .persistentStoreCoordinator
                .execute(deleteRequest,with: context)
            context.reset()
        } catch {
            print("Failed to delete users: \(error)")
        }
    }
    
    func saveUsers(_ users: [User]) {
        deleteAllUsers()
        for user in users {
            let entity = ProfileEntity(context: context)
            entity.uuid = user.id
            entity.firstName = user.name.first
            entity.lastName = user.name.last
            entity.age = Int16(user.dob.age)
            entity.city = user.location.city
            entity.state = user.location.state
            entity.imageURL = user.picture.large
            entity.status = MatchStatus.pending.rawValue
        }
        saveContext()
    }
    
    func fetchCachedUsers() -> [User] {

        let request: NSFetchRequest<ProfileEntity> =
            ProfileEntity.fetchRequest()

        do {

            let entities = try context.fetch(request)

            return entities.map { entity in

                User(
                    name: Name(
                        title: "",
                        first: entity.firstName ?? "",
                        last: entity.lastName ?? ""
                    ),
                    location: Location(
                        city: entity.city ?? "",
                        state: entity.state ?? ""
                    ),
                    dob: DOB(
                        age: Int(entity.age)
                    ),
                    picture: Picture(
                        large: entity.imageURL ?? ""
                    ),
                    login: Login(
                        uuid: entity.uuid ?? ""
                    ),
                    status: MatchStatus(
                        rawValue: entity.status ?? ""
                    ) ?? .pending
                )

            }

        } catch {

            return []

        }
    }
    
    func updateStatus(uuid: String, status: MatchStatus) {
        let request: NSFetchRequest<ProfileEntity> =
        ProfileEntity.fetchRequest()
        
        request.predicate =
        NSPredicate(format: "uuid == %@",uuid)
        do {
            let users =
            try context.fetch(request)
            if let user = users.first {
                user.status = status.rawValue
                saveContext()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func printAllUsers() {
        let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
        do {
            let users = try context.fetch(request)
            print("\n========== CoreData ==========")
            for user in users {
                print("""
                Name   : \(user.firstName ?? "") \(user.lastName ?? "")
                UUID   : \(user.uuid ?? "")
                Status : \(user.status ?? "")
                ------------------------------
                """)
            }
            print("==============================\n")
        } catch {
            print(error.localizedDescription)
        }
    }
}

