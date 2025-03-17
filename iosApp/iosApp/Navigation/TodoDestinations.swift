//
//  TodoDestinations.swift
//  iosApp
//
//  Created by Marcel Mravec on 17.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import Navigator
import shared

// Define all possible navigation destinations in the app
enum TodoDestinations {
    case list
    case addTodo(TodoListViewModel)
    case editTodo(TodoListViewModel, Todo)
}

// Explicitly implement Hashable for TodoDestinations
extension TodoDestinations: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .list:
            hasher.combine(0) // Use a unique integer for each case
        case .addTodo(let viewModel):
            hasher.combine(1)
            hasher.combine(ObjectIdentifier(viewModel)) // Use the object's memory address
        case .editTodo(let viewModel, let todo):
            hasher.combine(2)
            hasher.combine(ObjectIdentifier(viewModel)) // Use the object's memory address
            hasher.combine(todo.id)
        }
    }
    
    static func == (lhs: TodoDestinations, rhs: TodoDestinations) -> Bool {
        switch (lhs, rhs) {
        case (.list, .list):
            return true
        case (.addTodo(let lhsVM), .addTodo(let rhsVM)):
            return ObjectIdentifier(lhsVM) == ObjectIdentifier(rhsVM)
        case (.editTodo(let lhsVM, let lhsTodo), .editTodo(let rhsVM, let rhsTodo)):
            return ObjectIdentifier(lhsVM) == ObjectIdentifier(rhsVM) && lhsTodo.id == rhsTodo.id
        default:
            return false
        }
    }
}

// Extend TodoDestinations to conform to NavigationDestination
extension TodoDestinations: NavigationDestination {
    // Define how each destination should be presented
    var method: NavigationMethod {
        switch self {
        case .list:
            return .push
        case .addTodo:
            return .sheet
        case .editTodo:
            return .sheet
        }
    }
    
    // Define the view for each destination
    var body: some View {
        switch self {
        case .list:
            TodoListView()
        case .addTodo(let viewModel):
            AddTodoSheet(viewModel: viewModel)
        case .editTodo(let viewModel, let todo):
            EditTodoView(viewModel: viewModel, todo: todo)
        }
    }
}

// Define checkpoints for easy navigation
struct TodoCheckpoints: NavigationCheckpoints {
    static var list: NavigationCheckpoint<Void> { checkpoint() }
    // Optional: add checkpoint with callback value if needed
    static var addTodo: NavigationCheckpoint<Bool> { checkpoint() }
}
