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
    @Bindable var selectedTask: Task
    
    //MARK: Environment property wrappers.
    @Environment(\.modelContext) var modelContext: ModelContext
    @Environment(\.dismiss) var dismiss
    
    var exhibitionMode: ExhibitionMode
    
    var body: some View {
        VStack {
            Form {
                TextField("Description", text: $selectedTask.taskDescription)
                TextField("Status", text: $selectedTask.status)
                
                Section("Comments") {
                    if !selectedTask.comments.isEmpty {
                        ForEach(selectedTask.comments) { comment in
                            let commentView = CommentView(task: selectedTask,
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
        let commentView = CommentView(task: selectedTask,
                                      selectedComment: Comment(),
                                      exhibitionMode: .create)
        
        return NavigationLink(destination: commentView) {
            Text("Add comment")
        }
        .buttonStyle(.borderless)
    }
    
    func deleteComment(indexSet: IndexSet) {
        for index in indexSet {
            let comment = selectedTask.comments[index]
            selectedTask.comments.remove(at: index)
            modelContext.delete(comment)
        }
    }
    
    func saveTaskState() {
        if exhibitionMode == .create {
            let task = Task(taskDescription: selectedTask.taskDescription,
                            comments: [],
                            status: selectedTask.status)
            
            modelContext.insert(task)
            task.comments = selectedTask.comments
            project.tasks.append(task)
        }
        dismiss()
    }
}
