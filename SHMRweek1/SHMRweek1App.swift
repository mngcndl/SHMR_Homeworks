//
//  SHMRweek1App.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 18.06.2024.
//

import SwiftUI

@main
struct SHMRweek1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
