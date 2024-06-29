//
//  TodoListApp.swift
//  SHMRweek1
//
//  Created by Liubov Smirnova on 29.06.2024.
//

import Foundation
import SwiftUI


@main
struct TodoListItem: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ListView()
            }
            .environmentObject(listViewModel)
        }
    }
}
