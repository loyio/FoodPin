//
//  CoreDataTestApp.swift
//  CoreDataTest
//
//  Created by Loyio Hex on 1/31/22.
//

import SwiftUI

@main
struct CoreDataTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
