//
//  AddTodoSheet.swift
//  iosApp
//
//  Created by Marcel Mravec on 16.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct AddTodoSheet: View {
    @ObservedObject var viewModel: TodoListViewModel
    @Binding var isPresented: Bool
    @State private var title: String = ""
    @State private var isAdding: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Task")) {
                    TextField("Task title", text: $title)
                        .padding()
                        .submitLabel(.done)
                        .onSubmit {
                            if !title.isEmpty {
                                addTask()
                            }
                        }
                }
                
                Section {
                    Button(action: {
                        addTask()
                    }) {
                        if isAdding {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Add Task")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryGreen)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(title.isEmpty || isAdding)
                }
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addTask() {
        // Prevent multiple submissions
        guard !isAdding else { return }
        
        // Disable button while adding
        isAdding = true
        
        Task {
            let success = await viewModel.createTodo(title: title)
            isAdding = false
            
            if success {
                // Reset the form and close
                title = ""
                isPresented = false
            }
        }
    }
}

#Preview {
    AddTodoSheet(
        viewModel: TodoListViewModel(),
        isPresented: .constant(true)
    )
}
