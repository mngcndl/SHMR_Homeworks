//
//  TodoListApp.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 29.06.2024.
//

import Foundation
import SwiftUI
import CocoaLumberjack


@main
struct TodoListItem: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    init() {
        LoggerConfig.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }
            .environmentObject(listViewModel)
        }
    }
}
