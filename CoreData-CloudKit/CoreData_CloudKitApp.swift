//
//  CoreData_CloudKitApp.swift
//  CoreData-CloudKit
//
//  Created by Michael Luegmayer on 15.02.23.
//

import SwiftUI

@main
struct CoreData_CloudKitApp: App {
    @StateObject private var persistenceContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
