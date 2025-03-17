//
//  TodoListView.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Navigator
import SwiftUI
import shared

struct TodoListView: View {
    @StateObject private var viewModel = TodoListViewModel()
    @Environment(\.navigator) private var navigator
    
    var body: some View {
        NavigationStack {
            ZStack {
                todoList
                
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Checkmate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(
                Color.primaryGreen.opacity(0.9),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                leadingToolbarItems
                trailingToolbarItems
                bottomToolbarItems
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
            .animation(.easeInOut, value: viewModel.isLoading)
        }
        .onAppear {
            Task {
                await viewModel.fetchTodos()
            }
        }
    }
    
    // MARK: - View Components
    
    private var todoList: some View {
        List {
            ForEach(viewModel.todos, id:\.id) { todo in
                TodoRowView(
                    todo: todo,
                    onToggle: {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.toggleCompletion(for: todo)
                        }
                    },
                    onRowTap: {
                        // Navigate to the edit view when the row is tapped
                        navigator.navigate(to: TodoDestinations.editTodo(viewModel, todo))
                    }
                )
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
            }
            .onDelete { indexSet in
                viewModel.deleteTodo(at: indexSet)
            }
            .onMove { source, dest in
                viewModel.todos.move(fromOffsets: source, toOffset: dest)
            }
            .animation(.spring(response: 0.3), value: viewModel.todos)
        }
        .listStyle(.plain)
    }
    
    private var loadingOverlay: some View {
        ProgressView()
            .scaleEffect(1.5)
            .transition(.opacity)
    }
    
    // MARK: - Toolbar Items
    
    private var leadingToolbarItems: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
    }
    
    private var trailingToolbarItems: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                navigator.navigate(to: TodoDestinations.addTodo(viewModel))
            }) {
                Image(systemName: "plus")
            }
        }
    }
    
    private var bottomToolbarItems: ToolbarItem<(), some View> {
        ToolbarItem(placement: .bottomBar) {
            Text("Changes are local only (mock API)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    TodoListView()
}
