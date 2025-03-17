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
    // Default user ID to use for new todos
    private let defaultUserId = 1
    private let repository: TodoRepositoryProtocol
    
    init(repository: TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchTodos() async {
        self.isLoading = true
        do {
            print("Get some sleep to work better...")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Sleep has ended")
            print("Starting to fetch todos...")
            try await self.todos = repository.fetchTodos()
            print("Fetched todos count: \(self.todos.count)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("Error fetching todos.")
        }
        self.isLoading = false
    }
    
    func createTodo(title: String) async -> Bool {
        guard !title.isEmpty else {
            self.errorMessage = "Todo title cannot be empty"
            return false
        }
        
        isLoading = true
        do {
            let newTodo = try await repository.createTodo(title: title, userId: Int32(defaultUserId))
            
            // Add the new todo to the beginning of our list
            let localId = Int32.random(in: 10000..<Int32.max)
            let localTodo = Todo(id: localId, title: newTodo.title, completed: newTodo.completed, userId: newTodo.userId)
            self.todos.insert(localTodo, at: 0)
            
            // Note: We're not sorting by ID anymore to keep newest tasks at the top
            
            isLoading = false
            return true
        } catch {
            self.errorMessage = "Failed to create todo: \(error.localizedDescription)"
            print("Error creating todo: \(error.localizedDescription)")
            isLoading = false
            return false
        }
    }
    
    func toggleCompletion(for todo: Todo) {
        // Store original state
        let originalState = todo.completed
        
        // Immediately perform the change locally
        todo.toggle()
        Task {
            do {
                // Try to update on the server
                try await repository.toggleTodoCompletion(todo: todo)
            } catch {
                // Revert local state if server update fails
                todo.completed = originalState
                objectWillChange.send()
                
                // Show error message
                self.errorMessage = "Failed to update task: \(error.localizedDescription)"
            }
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
        let originalTitle = todo.title
        
        // Immediately perform the change locally
        todo.title = newTitle
        objectWillChange.send()
        
        Task {
            do {
                // Try to update on the server
                try await repository.updateTodoTitle(todo: todo, newTitle: newTitle)
                completion?(true)
            } catch {
                // Revert local state if server update fails
                todo.title = originalTitle
                objectWillChange.send()
                
                // Show error message
                self.errorMessage = "Failed to update title: \(error.localizedDescription)"
                completion?(false)
            }
        }
    }
    
    func deleteTodo(at indexSet: IndexSet) {
        // Store the todos that will be deleted
        let todosToDelete = indexSet.map { self.todos[$0] }
        
        // Remove them from the local array first (optimistic UI update)
        self.todos.remove(atOffsets: indexSet)
        
        // Then try to delete them on the server
        for todo in todosToDelete {
            Task {
                do {
                    let kotlinSuccess = try await repository.deleteTodo(id: Int32(todo.id))
                    // Convert KotlinBoolean to Swift Bool
                    let success = kotlinSuccess
                    if !success {
                        // If the server operation failed, add the todo back to the array
                        self.errorMessage = "Server couldn't delete todo #\(todo.id)"
                        self.todos.append(todo)
                        // Re-sort the array to maintain order
                        self.todos.sort { $0.id < $1.id }
                    }
                } catch {
                    // If an error occurred, add the todo back to the array
                    self.errorMessage = "Failed to delete todo: \(error.localizedDescription)"
                    self.todos.append(todo)
                    // Re-sort the array to maintain order
                    self.todos.sort { $0.id < $1.id }
                }
            }
        }
    }
}

