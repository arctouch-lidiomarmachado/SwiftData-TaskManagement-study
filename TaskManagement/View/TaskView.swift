//
//  TaskView.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import SwiftUI
import SwiftData

struct TaskView: View {
    //MARK: Bindable property wrappers.
    @Bindable var project: Project
    @Bindable var task: Task
    
    //MARK: Environment property wrappers.
    @Environment(\.modelContext) var modelContext: ModelContext
    @Environment(\.dismiss) var dismiss
    
    var exhibitionMode: ExhibitionMode
    
    var body: some View {
        VStack {
            Form {
                TextField("Description", text: $task.taskDescription)
                TextField("Status", text: $task.status)
                
                Section("Comments") {
                    if !task.comments.isEmpty {
                        ForEach(task.comments) { comment in
                            let commentView = CommentView(task: task,
                                                          selectedComment: comment,
                                                          exhibitionMode: .update)
                            
                            NavigationLink(destination: commentView) {
                                Text(comment.commentDescription)
                            }
                        }.onDelete(perform: deleteComment)
                    } else {
                        Text("No comments created.")
                    }
                }
            }
            Button("Save", action: saveTaskState)
        }.toolbar {
            addCommentNavigationLink()
        }.navigationTitle("Task")
    }
}

private extension TaskView {
    func addCommentNavigationLink() -> some View {
        let commentView = CommentView(task: task,
                                      selectedComment: Comment(),
                                      exhibitionMode: .create)
        
        return NavigationLink(destination: commentView) {
            Text("Add comment")
        }
        .buttonStyle(.borderless)
    }
    
    func deleteComment(indexSet: IndexSet) {
        for index in indexSet {
            let comment = task.comments[index]
            task.comments.remove(at: index)
            do {
                modelContext.delete(comment)
                try modelContext.save()
            } catch {
                print(error)
            }
            
        }
    }
    
    func saveTaskState() {
        if exhibitionMode == .create {
            modelContext.insert(task)
            project.tasks.append(task)
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
    
    let comment = Comment(commentDescription: "A simple comment")
    let comment2 = Comment(commentDescription: "Another comment")
    
    modelContext.insert(comment)
    modelContext.insert(comment2)
    
    task.comments.append(comment)
    task.comments.append(comment2)
    
    project.tasks.append(task)
    
    return TaskView(project: project, 
                    task: task,
                    exhibitionMode: .update).modelContainer(modelContainer)
}
