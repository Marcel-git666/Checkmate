package com.marcel.checkmate.model

import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class TodoTest {
    @Test
    fun testToggle() {
        val todo = Todo(
            id = 1,
            title = "Test Todo",
            completed = false,
            userId = 1
        )

        assertFalse(todo.completed)

        todo.toggle()

        assertTrue(todo.completed)

        todo.toggle()

        assertFalse(todo.completed)
    }
}