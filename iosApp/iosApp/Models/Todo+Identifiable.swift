//
//  Todo+Identifiable.swift
//  iosApp
//
//  Created by Marcel Mravec on 16.03.2025.
//  Copyright © 2025 orgName. All rights reserved.
//

import Foundation
import shared

extension Todo: @retroactive Identifiable {
    // The id property is already in your Kotlin class,
    // so you don't need to redefine it
    static var sample1: Todo {
        return Todo(id: 1, title: "Buy groceries", completed: false, userId: 1)
    }
    
    static var sample2: Todo {
        return Todo(id: 2, title: "Complete SwiftUI tutorial", completed: true, userId: 1)
    }
    
    static var todos: [Todo] {
        [sample1, sample2]
    }
}
