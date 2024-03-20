//
//  Project.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import Foundation
import SwiftData

@Model
class Project {
    var projectDescription: String
    var name: String
    var startDate: Date
    var endDate: Date
    @Relationship(deleteRule: .cascade) var  tasks: [Task]
    
    init(projectDescription: String = "", name: String = "", startDate: Date = .now, endDate: Date = .now, tasks: [Task] = []) {
        self.projectDescription = projectDescription
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.tasks = tasks
    }
}
    
