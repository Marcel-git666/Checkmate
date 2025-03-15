//
//  TodoListViewModel.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared

class TodoListViewModel: ObservableObject {
    @Published var todos: [TodoModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    let sdk = TodoSDK()
    
    func fetchTodos() {
        isLoading = true
        sdk.fetchTodos { [weak self] todos, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.message ?? "Unknown error"
                    return
                }
                
                if let todos = todos {
                    self?.todos = todos.map { TodoModel(original: $0) }
                }
            }
        }
    }
    
    func toggleCompletion(for todo: TodoModel) {
        // Immediately perform the change locally
        todo.completed.toggle()
        
        // Update the original model for potential API call
        todo.updateOriginal()
        
        // Send the change to API (knowing it's a mock)
        sdk.toggleTodoCompletion(todo: todo.original) { [weak self] updatedTodo, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Show error, but DON'T revert local change
                    self?.errorMessage = "Change couldn't be saved to server (mock API): \(error.message ?? "Unknown error")"
                }
                
                // Even in case of success, we won't use the returned data,
                // because we know the mock API doesn't actually change anything
            }
        }
        
        // Important: We must explicitly notify that the object has changed (for reference types)
        objectWillChange.send()
    }
    
    func updateTodoTitle(for todo: TodoModel, newTitle: String, completion: ((Bool) -> Void)? = nil) {
        // Don't do anything if the title hasn't changed
        guard newTitle != todo.title else {
            completion?(false)
            return
        }
        
        // Immediately perform the change locally
        todo.title = newTitle
        
        // Update the original model for potential API call
        todo.updateOriginal()
        
        // Send the change to API (knowing it's a mock)
        sdk.updateTodoTitle(todo: todo.original, newTitle: newTitle) { [weak self] updatedTodo, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Show error, but DON'T revert local change
                    self?.errorMessage = "Change couldn't be saved to server (mock API): \(error.message ?? "Unknown error")"
                    completion?(false)
                    return
                }
                
                // Even in case of success, we won't use the returned data,
                // because we know the mock API doesn't actually change anything
                completion?(true)
            }
        }
        
        // Important: We must explicitly notify that the object has changed
        objectWillChange.send()
    }
}
