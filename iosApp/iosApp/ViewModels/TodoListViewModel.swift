//
//  TodoListViewModel.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared

@MainActor
class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func myfetchTodos() async {
        do {
            try await self.todos = TodoRepository().fetchTodos()
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching todos.")
        }
    }
      
    func toggleCompletion(for todo: Todo) {
        // Immediately perform the change locally
        todo.toggle()
        Task {
            try await TodoRepository().toggleTodoCompletion(todo: todo)
            
        }
        // Important: We must explicitly notify that the object has changed (for reference types)
        objectWillChange.send()
    }
    
    func updateTodoTitle(for todo: Todo, newTitle: String, completion: ((Bool) -> Void)? = nil) {
        // Don't do anything if the title hasn't changed
        guard newTitle != todo.title else {
            completion?(false)
            return
        }
        
        // Immediately perform the change locally
        todo.title = newTitle

        
        // Important: We must explicitly notify that the object has changed
        objectWillChange.send()
    }
}
