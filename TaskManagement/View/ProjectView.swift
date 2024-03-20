//
//  ProjectView.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import SwiftUI
import SwiftData

struct ProjectView: View {
    //MARK: Environment property wrappers.
    @Environment(\.modelContext) var modelContext: ModelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var project: Project
    var exhibitionMode: ExhibitionMode
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $project.name)
                TextField("Description", text: $project.projectDescription)
                DatePicker("Start Date", selection: $project.startDate)
                DatePicker("End Date", selection: $project.endDate)
                
                Section("Tasks") {
                    if !project.tasks.isEmpty {
                        ForEach(project.tasks) { task in
                            NavigationLink(destination: TaskView(project: project,
                                                                 task: task,
                                                                 exhibitionMode: .update)) {
                                Text(task.taskDescription)
                            }
                        }.onDelete(perform: deleteTask)
                    } else {
                        Text("No tasks created.")
                    }
                }
            }
            Button(buttonDescription(), action: addNewProject)
        }.toolbar {
            addTaskNavigationLink()
        }.navigationTitle("Project")
    }
}

//MARK: private functions
private extension ProjectView {
    func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            let task = project.tasks[index]
            project.tasks.remove(at: index)
            
            do {
                modelContext.delete(task)
                try modelContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    func addTaskNavigationLink() -> some View {
        let taskView = TaskView(project: project, task: Task(), exhibitionMode: .create)
        return NavigationLink(destination: taskView) {
            Text("Add task")
        }
        .buttonStyle(.borderless)
    }
    
    func buttonDescription() -> String {
        switch exhibitionMode {
        case .create:
            return "Create"
        case .update:
            return "Update"
        }
    }
    
    func addNewProject() {
        do {
            modelContext.insert(project)
            try modelContext.save()
        } catch {
            print(error)
        }
        dismiss()
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
    
    let task = Task(taskDescription: "A simple task", 
                    comments: [],
                    status: "open")
    
    modelContext.insert(task)
    project.tasks.append(task)
    
    return ProjectView(project: project, exhibitionMode: .create).modelContainer(modelContainer)
}
