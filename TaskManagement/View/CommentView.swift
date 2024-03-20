//
//  CommentView.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 22/01/24.
//

import SwiftUI
import SwiftData

struct CommentView: View {
    //MARK: Bindable property wrappers.
    @Bindable var task: Task
    @Bindable var selectedComment: Comment
    
    //MARK: Environment property wrappers.
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext: ModelContext
    
    var exhibitionMode: ExhibitionMode
    
    var body: some View {
        VStack {
            Form {
                TextField("", text: $selectedComment.commentDescription)
            }
            Button("Save", action: saveCommentState)
        }.navigationTitle("Comment")
    }
}

private extension CommentView {
    func saveCommentState() {
        if exhibitionMode == .create {
            let comment = Comment(commentDescription: selectedComment.commentDescription)
            modelContext.insert(comment)
            task.comments.append(comment)
        }
        dismiss()
    }
}

#Preview {
    let modelConfiguration = ModelConfiguration(isStoredInMemoryOnly: true)
    let modelContainer = try! ModelContainer(for: Project.self, configurations: modelConfiguration)
    let modelContext = ModelContext(modelContainer)
    
    let task = Task(taskDescription: "A simple task",
                    comments: [],
                    status: "open")
    
    let comment = Comment(commentDescription: "A simple comment")
    modelContext.insert(comment)
    task.comments.append(comment)
    
    return CommentView(task: task, selectedComment: comment, exhibitionMode: .update).modelContainer(modelContainer)
}

