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
    @State private var selectedTodo: TodoModel? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.todos) { todo in
                        TodoRowView(
                            todo: todo,
                            onToggle: {
                                viewModel.toggleCompletion(for: todo)
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTodo = todo
                        }
                    }
                }
                .listStyle(.plain)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Checkmate")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text("Changes are local only (mock API)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Notice"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(item: $selectedTodo) { todo in
                TodoDetailView(viewModel: viewModel, todo: todo)
            }
        }
        .onAppear {
            viewModel.fetchTodos()
        }
    }
}
#Preview {
    TodoListView()
}
