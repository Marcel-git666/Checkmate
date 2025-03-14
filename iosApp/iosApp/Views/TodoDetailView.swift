//
//  TodoDetailView.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct TodoDetailView: View {
    @ObservedObject var viewModel: TodoListViewModel
    @State private var todo: TodoModel
    @State private var editedTitle: String
    
    init(todo: TodoModel, viewModel: TodoListViewModel) {
        self.viewModel = viewModel
        _todo = State(initialValue: todo)
        _editedTitle = State(initialValue: todo.title)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Title", text: $editedTitle)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Toggle("Completed", isOn: Binding(
                    get: { todo.completed },
                    set: {
                        todo.completed = $0
                        todo.updateOriginal()
                        viewModel.toggleCompletion(for: todo)
                    }
                ))
                .padding()
                
                Text("Task ID: \(todo.id)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("User ID: \(todo.userId)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Section {
                Button("Update Title") {
                    todo.title = editedTitle
                    todo.updateOriginal()
                    
                    viewModel.sdk.updateTodoTitle(todo: todo.original, newTitle: editedTitle) { updatedTodo, error in
                        DispatchQueue.main.async {
                            if let error = error {
                                viewModel.errorMessage = error.message ?? "Unknown error"
                                return
                            }
                            
                            if let updatedTodo = updatedTodo {
                                todo.original = updatedTodo
                                
                                // Find and update the todo in our list
                                if let index = viewModel.todos.firstIndex(where: { $0.id == Int(updatedTodo.id) }) {
                                    viewModel.todos[index].title = updatedTodo.title
                                    viewModel.todos[index].original = updatedTodo
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(editedTitle == todo.title)
            }
        }
        .navigationTitle("Task Details")
    }
}

//#Preview {
//    TodoDetailView()
//}
