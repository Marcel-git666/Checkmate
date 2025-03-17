//
//  KMPTodoRepository.swift
//  iosApp
//
//  Created by Marcel Mravec on 17.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared

@MainActor
class KMPTodoRepository: TodoRepositoryProtocol {
    private let kotlinRepository = TodoRepository()
    
    func fetchTodos() async throws -> [Todo] {
        return try await kotlinRepository.fetchTodos()
    }
    
    func fetchTodo(id: Int32) async throws -> Todo {
        return try await kotlinRepository.fetchTodo(id: id)
    }
    
    func createTodo(title: String, userId: Int32) async throws -> Todo {
        return try await kotlinRepository.createTodo(title: title, userId: userId)
    }
    
    func updateTodoTitle(todo: Todo, newTitle: String) async throws -> Todo {
        return try await kotlinRepository.updateTodoTitle(todo: todo, newTitle: newTitle)
    }
    
    func toggleTodoCompletion(todo: Todo) async throws -> Todo {
        return try await kotlinRepository.toggleTodoCompletion(todo: todo)
    }
    
    func deleteTodo(id: Int32) async throws -> Bool {
        let result = try await kotlinRepository.deleteTodo(id: id)
        return result.boolValue
    }
}
