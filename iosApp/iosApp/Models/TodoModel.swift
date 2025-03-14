//
//  TodoModel.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared

// Wrapper around the KMP Todo model
class TodoModel: Identifiable {
    let id: Int
    var title: String
    var completed: Bool
    let userId: Int
    
    // Original KMP model
    var original: Todo
    
    init(original: Todo) {
        self.original = original
        self.id = Int(original.id)
        self.title = original.title
        self.completed = original.completed
        self.userId = Int(original.userId)
    }
    
    // Create a new KMP Todo model when properties change
    func updateOriginal() {
        self.original = Todo(id: Int32(id), title: title, completed: completed, userId: Int32(userId))
    }
}
