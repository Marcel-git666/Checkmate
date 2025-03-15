//
//  TodoRowView.swift
//  iosApp
//
//  Created by Marcel Mravec on 14.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import SwiftUI

struct TodoRowView: View {
    let todo: TodoModel
    let onToggle: () -> Void
    
    @State private var checkScale: CGFloat = 1.0
    
    var body: some View {
        HStack {
            Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.completed ? .green : .gray)
                .imageScale(.large)
                .scaleEffect(checkScale)
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
            Text(todo.title)
                .strikethrough(todo.completed)
                .foregroundColor(todo.completed ? .gray : .primary)
                .lineLimit(1)
                .padding(.vertical, 8)
        }
    }
}


#Preview {
    VStack {
        TodoRowView(
            todo: TodoModel.sample1,
            onToggle: {}
        )
        TodoRowView(
            todo: TodoModel.sample2,
            onToggle: {}
        )
    }
}
