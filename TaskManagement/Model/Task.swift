//
//  Task.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import Foundation
import SwiftData

@Model
class Task {
    let id = UUID()
    var taskDescription: String 
    var comments: [Comment]
    var status: String
    
    init(taskDescription: String = "",
         comments: [Comment] = [],
         status: String = "") {
        self.taskDescription = taskDescription
        self.comments = comments
        self.status = status
    }
}
