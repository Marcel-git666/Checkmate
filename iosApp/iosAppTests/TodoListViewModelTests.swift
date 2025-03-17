//
//  TodoListViewModelTests.swift
//  iosAppTests
//
//  Created by Marcel Mravec on 17.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Testing
@testable import iosApp
import shared

@MainActor
struct TodoListViewModelTests {
    
    @Test func initialState() {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        #expect(viewModel.todos.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func fetchTodos() async throws {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        await viewModel.fetchTodos()
        
        #expect(viewModel.todos.count == 2)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage == nil)
    }
    
    @Test func fetchTodosError() async throws {
        let mockRepository = MockTodoRepository()
        mockRepository.shouldFailNextOperation = true
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        await viewModel.fetchTodos()
        
        #expect(viewModel.todos.isEmpty)
        #expect(!viewModel.isLoading)
        #expect(viewModel.errorMessage != nil)
    }
    
    @Test func createTodo() async throws {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        let initialCount = viewModel.todos.count
        let success = await viewModel.createTodo(title: "New Test Todo")
        
        #expect(success)
        #expect(viewModel.todos.count == initialCount + 1)
        #expect(viewModel.todos[0].title == "New Test Todo")
    }
    
    @Test func createEmptyTodo() async throws {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        let initialCount = viewModel.todos.count
        let success = await viewModel.createTodo(title: "")
        
        #expect(!success)
        #expect(viewModel.todos.count == initialCount)
        #expect(viewModel.errorMessage == "Todo title cannot be empty")
    }
    
    @Test func toggleCompletion() async throws {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        let todo = Todo.sample1
        let originalCompletedState = todo.completed
        
        viewModel.todos = [todo]
        viewModel.toggleCompletion(for: todo)
        
        #expect(todo.completed != originalCompletedState)
    }
    
    @Test func updateTodoTitle() async throws {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        let todo = Todo.sample1
        viewModel.todos = [todo]
        
        // Use async/await to handle the completion callback
        let success = try await withCheckedThrowingContinuation { continuation in
            viewModel.updateTodoTitle(for: todo, newTitle: "Updated Title") { success in
                continuation.resume(returning: success)
            }
        }
        
        #expect(success)
        #expect(todo.title == "Updated Title")
    }
    
    @Test func deleteTodo() async throws {
        let mockRepository = MockTodoRepository()
        let viewModel = TodoListViewModel(repository: mockRepository)
        
        let todo1 = Todo.sample1
        let todo2 = Todo.sample2
        viewModel.todos = [todo1, todo2]
        
        let initialCount = viewModel.todos.count
        viewModel.deleteTodo(at: IndexSet(integer: 0))
        
        #expect(viewModel.todos.count == initialCount - 1)
        #expect(!viewModel.todos.contains(where: { $0.id == todo1.id }))
    }
    
}
