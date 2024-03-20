//
//  Comment.swift
//  TaskManagement
//
//  Created by Lidiomar Fernando dos Santos Machado on 21/01/24.
//

import Foundation
import SwiftData

@Model
class Comment {
    var commentDescription: String
    
    init(commentDescription: String = "") {
        self.commentDescription = commentDescription
    }
}

