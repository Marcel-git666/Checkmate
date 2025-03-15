//
//  TodoListView.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

extension Todo: Identifiable {
    // The id property is already in your Kotlin class,
    // so you don't need to redefine it
}

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var selectedTodo: Todo? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.todos, id:\.id) { todo in
                        TodoRowView(
                            todo: todo,
                            onToggle: {
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.toggleCompletion(for: todo)
                                }
                            }
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedTodo = todo
                        }
                        .listRowBackground(selectedTodo?.id == todo.id ? Color.green.opacity(0.2) : Color.clear)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                    .onDelete { offsets in
                        viewModel.todos.remove(atOffsets: offsets)
                    }
                    .onMove { source, dest in
                        viewModel.todos.move(fromOffsets: source, toOffset: dest)
                    }
                    .animation(.spring(response: 0.3), value: viewModel.todos)
                }
                .toolbar {
                    ToolbarItem { EditButton() }
                }
                .listStyle(.plain)
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .transition(.opacity)
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
            .animation(.easeInOut, value: viewModel.isLoading)
        }
        .onAppear {
            Task {
                await viewModel.myfetchTodos()
            }
        }
    }
}

#Preview {
    TodoListView()
}
