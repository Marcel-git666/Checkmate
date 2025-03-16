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
}
