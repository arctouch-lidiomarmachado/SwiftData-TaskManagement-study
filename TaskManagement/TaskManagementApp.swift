//
//  TaskManagementApp.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import SwiftUI
import SwiftData

@main
struct TaskManagementApp: App {    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: Project.self, isAutosaveEnabled: false)
    }
}
