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
    
    let customLocation: ModelContainer = {
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directoryURL = appSupportURL.appendingPathComponent("TaskManagement")
        
        let fileURL = directoryURL.appendingPathComponent("TaskManagement.store")
        let schema = Schema([Project.self])
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            let defaultConfiguration = ModelConfiguration("TaskManagement", schema: schema, url: fileURL)
            do {
                return try ModelContainer(
                    for: schema,
                    configurations: defaultConfiguration
                )
             } catch {
                fatalError("Could not initialise the container…")
            }
        } catch {
            fatalError("Could not find/create Example folder in Application Support")
        }
    }()
    
    let container: ModelContainer = {
        do {
            return try ModelContainer(for: Project.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(container)
    }
}
