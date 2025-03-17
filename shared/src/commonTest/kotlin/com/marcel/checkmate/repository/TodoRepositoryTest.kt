package com.marcel.checkmate.repository

import com.marcel.checkmate.model.Todo
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertTrue
import kotlin.test.assertFalse

class TodoRepositoryTest {
    private val repository = TodoRepository()

    @Test
    fun testCreateTodo() = runTest {
        val title = "Test Todo"
        val userId = 1

        val createdTodo = repository.createTodo(title, userId)

        assertNotNull(createdTodo)
        assertEquals(title, createdTodo.title)
        assertEquals(userId, createdTodo.userId)
        assertFalse(createdTodo.completed)
        assertTrue(createdTodo.id > 0)
    }

    @Test
    fun testToggleTodoCompletion() = runTest {
        val originalTodo = Todo(
            id = 1,
            title = "Original Todo",
            completed = false,
            userId = 1
        )

        val toggledTodo = repository.toggleTodoCompletion(originalTodo)

        assertNotNull(toggledTodo)
        assertTrue(toggledTodo.completed)
        assertEquals(originalTodo.id, toggledTodo.id)
        assertEquals(originalTodo.title, toggledTodo.title)
    }
}