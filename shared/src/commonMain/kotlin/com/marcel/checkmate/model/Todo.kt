package com.marcel.checkmate.model

import kotlinx.serialization.Serializable

@Serializable
data class Todo(
    val id: Int,
    var title: String,
    var completed: Boolean,
    val userId: Int
) {
    fun toggle() {
        this.completed = !this.completed
    }
}