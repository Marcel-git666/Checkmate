//
//  TodoListView.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.todos) { todo in
                        NavigationLink(destination: TodoDetailView(todo: todo, viewModel: viewModel)) {
                            TodoRowView(todo: todo, onToggle: {
                                viewModel.toggleCompletion(for: todo)
                            })
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Checkmate")
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .onAppear {
            viewModel.fetchTodos()
        }
    }
}

struct TodoRowView: View {
    let todo: TodoModel
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.completed ? .green : .gray)
                .imageScale(.large)
                .onTapGesture {
                    onToggle()
                }
            
            Text(todo.title)
                .strikethrough(todo.completed)
                .foregroundColor(todo.completed ? .gray : .primary)
                .lineLimit(1)
                .padding(.vertical, 8)
        }
    }
}

#Preview {
    TodoListView()
}
