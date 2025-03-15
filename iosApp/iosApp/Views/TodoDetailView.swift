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
    @Environment(\.dismiss) private var dismiss
    @State private var titleUpdated = false
    @State private var updateButtonScale: CGFloat = 1.0
    
    init(viewModel: TodoListViewModel, todo: TodoModel) {
        self.viewModel = viewModel
        _todo = State(initialValue: todo)
        _editedTitle = State(initialValue: todo.title)
    }
    
    private func handleTitleUpdate() {
        // Button press animation
        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
            updateButtonScale = 0.95
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                updateButtonScale = 1.0
            }
            
            // Call the ViewModel method which handles the actual data update
            viewModel.updateTodoTitle(for: todo, newTitle: editedTitle) { success in
                if success {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        titleUpdated = true
                    }
                    
                    // Reset the "Updated" text after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            titleUpdated = false
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $editedTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onSubmit {
                            // Trigger update when Enter is pressed
                            handleTitleUpdate()
                        }
                    
                    Toggle("Completed", isOn: Binding(
                        get: { todo.completed },
                        set: { _ in
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.toggleCompletion(for: todo)
                            }
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
                    Button(titleUpdated ? "Title Updated!" : "Update Title") {
                        handleTitleUpdate()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(titleUpdated ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .scaleEffect(updateButtonScale)
                    .disabled(editedTitle == todo.title)
                    .animation(.easeInOut(duration: 0.2), value: titleUpdated)
                }
            }
            .navigationTitle("Task Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Save any pending title changes before dismissing
                        if editedTitle != todo.title {
                            viewModel.updateTodoTitle(for: todo, newTitle: editedTitle)
                        }
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Text("Changes are local only (mock API)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    TodoDetailView(
        viewModel: TodoListViewModel(),
        todo: TodoModel.sample1
    )
}
