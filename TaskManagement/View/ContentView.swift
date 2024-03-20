//
//  ContentView.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    @Query var projects: [Project]
    @State private var path = [Project]()
    
    var body: some View {
        
        let _ = print(modelContext.sqliteCommand)
        
        NavigationStack(path: $path) {
            List {
                ForEach(projects) { project in                    
                    NavigationLink(destination: ProjectView(project: project, exhibitionMode: .update)) {
                        VStack(alignment: .leading) {
                            Text(project.name)
                            Text(project.projectDescription)
                        }
                    }
                }.onDelete(perform: deleteProject)
            }
            .toolbar {
                Button("Add Project", action: addDestination)
            }
            .navigationDestination(for: Project.self, destination: { project in
                ProjectView(project: project, exhibitionMode: .create)
            })
            .navigationTitle("Projects")
        }
    }
}

private extension ContentView {
    func deleteProject(indexSet: IndexSet) {
        for index in indexSet {
            let project = projects[index]
            
            do {
                modelContext.delete(project)
                try modelContext.save()
            } catch {
                print(error)
            }
            
        }
    }
    
    func addDestination() {
        let project = Project()
        path = [project]
    }
}

#Preview {
    let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Project.self, configurations: modelConfiguration)
    let modelContext = ModelContext(modelContainer)
    
    let project = Project(projectDescription: "Project 1", 
                          name: "Project 1 description",
                          startDate: Date(),
                          endDate: Date())
    
    let project2 = Project(projectDescription: "Project 2", 
                           name: "Project 2 description",
                           startDate: Date(),
                           endDate: Date())
    
    modelContext.insert(project2)
    modelContext.insert(project)
    
    return ContentView().modelContainer(modelContainer)
}
