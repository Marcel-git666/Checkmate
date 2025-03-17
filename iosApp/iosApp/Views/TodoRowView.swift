//
//  TodoRowView.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI
import shared

struct TodoRowView: View {
    let todo: Todo
    let onToggle: () -> Void
    let onRowTap: () -> Void  // New callback for row taps
    
    @State private var checkScale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 0) {
            // Checkbox area - only this will toggle completion
            checkboxView
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        checkScale = 0.8
                    }
                    
                    // Small delay before scaling back
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            checkScale = 1.0
                        }
                        onToggle()
                    }
                }
                .padding(.trailing, 8)
            
            // Text content - this entire area will open the edit screen
            textContent
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    onRowTap()
                }
        }
    }
    
    // Checkbox component
    private var checkboxView: some View {
        Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
            .foregroundColor(todo.completed ? Color.accentGreen : .gray)
            .imageScale(.large)
            .scaleEffect(checkScale)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
    }
    
    // Text content component
    private var textContent: some View {
        Text(todo.title)
            .strikethrough(todo.completed)
            .foregroundColor(todo.completed ? .gray : .primary)
            .lineLimit(1)
            .padding(.vertical, 8)
    }
}

#Preview {
    VStack {
        TodoRowView(
            todo: Todo.sample1,
            onToggle: {},
            onRowTap: {}
        )
        TodoRowView(
            todo: Todo.sample2,
            onToggle: {},
            onRowTap: {}
        )
    }
}
