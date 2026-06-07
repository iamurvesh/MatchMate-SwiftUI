//
//  MatchMateApp.swift
//  MatchMate
//
//  Created by Apple on 07/06/26.
//

import SwiftUI
import CoreData

@main
struct MatchMateApp: App {
    let persistenceController = CoreDataManager.shared
    var body: some Scene {
        WindowGroup {
            MatchListView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
        }
    }
}
