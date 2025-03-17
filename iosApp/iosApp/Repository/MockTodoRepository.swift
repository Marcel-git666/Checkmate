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
    var todos: [Todo] = [Todo.sample1, Todo.sample2]
    var shouldFailNextOperation = false
    var errorToThrow: Error = NSError(domain: "Mock", code: 500)
    
    func fetchTodos() async throws -> [Todo] {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        return todos
    }
    
    func fetchTodo(id: Int32) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        guard let todo = todos.first(where: { $0.id == id }) else {
            throw NSError(domain: "Mock", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
        }
        
        return todo
    }
    
    func createTodo(title: String, userId: Int32) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        let maxId = todos.map { $0.id }.max() ?? 0
        let newTodo = Todo(id: maxId + 1, title: title, completed: false, userId: userId)
        todos.append(newTodo)
        return newTodo
    }
    
    func updateTodoTitle(todo: Todo, newTitle: String) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            throw NSError(domain: "Mock", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
        }
        
        todos[index].title = newTitle
        return todos[index]
    }
    
    func toggleTodoCompletion(todo: Todo) async throws -> Todo {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            throw NSError(domain: "Mock", code: 404, userInfo: [NSLocalizedDescriptionKey: "Todo not found"])
        }
        
        todos[index].toggle()
        return todos[index]
    }
    
    func deleteTodo(id: Int32) async throws -> Bool {
        if shouldFailNextOperation {
            throw errorToThrow
        }
        
        let initialCount = todos.count
        todos.removeAll { $0.id == id }
        return todos.count < initialCount
    }
}
