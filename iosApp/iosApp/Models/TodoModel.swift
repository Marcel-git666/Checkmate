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
class TodoModel: Identifiable, Equatable {
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
    
    static func == (lhs: TodoModel, rhs: TodoModel) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.completed == rhs.completed
    }
}

extension TodoModel {
    static let sample1 = TodoModel(original: Todo(id: 999, title: "Nice and long work to do.", completed: true, userId: 99))
    static let sample2 = TodoModel(original: Todo(id: 666, title: "Sysiphos's job.", completed: false, userId: 99))
}
