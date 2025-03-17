//
//  MockTodoRepository.swift
//  iosApp
//
//  Created by Marcel Mravec on 17.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//
import Foundation
import shared

@MainActor
class MockTodoRepository: TodoRepositoryProtocol {
    var shouldFailNextOperation = false
    var errorToThrow: Error = NSError(domain: "Mock", code: 500)
    
    // Initial sample todos for reference
    private let initialTodos: [Todo] = [Todo.sample1, Todo.sample2]
    
    func fetchTodos() async throws -> [Todo] {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        return initialTodos
    }
    
    func fetchTodo(id: Int32) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        guard let todo = initialTodos.first(where: { $0.id == id }) else {
            throw NSError(domain: "Mock", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
        }
        
        return todo
    }
    
    func createTodo(title: String, userId: Int32) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        // Generate a new todo with a unique ID
        return Todo(
            id: Int32.random(in: 1000...Int32.max),
            title: title,
            completed: false,
            userId: userId
        )
    }
    
    func updateTodoTitle(todo: Todo, newTitle: String) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        // Return a new todo with updated title
        return Todo(
            id: todo.id,
            title: newTitle,
            completed: todo.completed,
            userId: todo.userId
        )
    }
    
    func toggleTodoCompletion(todo: Todo) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        // Return a new todo with toggled completion
        return Todo(
            id: todo.id,
            title: todo.title,
            completed: !todo.completed,
            userId: todo.userId
        )
    }
    
    func deleteTodo(id: Int32) async throws -> Bool {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        // Simulate successful deletion
        return true
    }
}
