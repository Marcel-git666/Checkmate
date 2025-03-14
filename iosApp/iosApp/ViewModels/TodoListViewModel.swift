//
//  TodoListViewModel.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared
import Combine

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
        todo.updateOriginal() // Make sure we have the latest state
        
        sdk.toggleTodoCompletion(todo: todo.original) { [weak self] updatedTodo, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.message ?? "Unknown error"
                    return
                }
                
                if let updatedTodo = updatedTodo {
                    // Find and update the todo in our list
                    if let index = self?.todos.firstIndex(where: { $0.id == Int(updatedTodo.id) }) {
                        self?.todos[index].completed = updatedTodo.completed
                        self?.todos[index].original = updatedTodo
                    }
                }
            }
        }
    }
} 
