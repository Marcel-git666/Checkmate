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
