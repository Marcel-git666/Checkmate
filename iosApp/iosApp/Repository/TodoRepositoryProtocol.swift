//
//  TodoRepositoryProtocol.swift
//  iosApp
//
//  Created by Marcel Mravec on 17.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared

@MainActor
protocol TodoRepositoryProtocol {
    func fetchTodos() async throws -> [Todo]
    func fetchTodo(id: Int32) async throws -> Todo
    func createTodo(title: String, userId: Int32) async throws -> Todo
    func updateTodoTitle(todo: Todo, newTitle: String) async throws -> Todo
    func toggleTodoCompletion(todo: Todo) async throws -> Todo
    func deleteTodo(id: Int32) async throws -> Bool
}
