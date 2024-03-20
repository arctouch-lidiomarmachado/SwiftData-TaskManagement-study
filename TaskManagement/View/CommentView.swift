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
