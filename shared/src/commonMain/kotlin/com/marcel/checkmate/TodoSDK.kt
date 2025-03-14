package com.marcel.checkmate

import com.marcel.checkmate.model.Todo
import com.marcel.checkmate.repository.TodoRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class TodoSDK {
    private val repository = TodoRepository()
    private val scope = CoroutineScope(Dispatchers.Default + Job())

    // Method to fetch all todo items
    fun fetchTodos(completion: (List<Todo>?, Exception?) -> Unit) {
        scope.launch {
            try {
                val todos = repository.fetchTodos()
                completion(todos, null)
            } catch (e: Exception) {
                completion(null, e)
            }
        }
    }

    // Method to fetch a single todo by ID
    fun fetchTodo(id: Int, completion: (Todo?, Exception?) -> Unit) {
        scope.launch {
            try {
                val todo = repository.fetchTodo(id)
                completion(todo, null)
            } catch (e: Exception) {
                completion(null, e)
            }
        }
    }

    // Method to toggle the completion status of a todo
    fun toggleTodoCompletion(todo: Todo, completion: (Todo?, Exception?) -> Unit) {
        scope.launch {
            try {
                val updatedTodo = repository.toggleTodoCompletion(todo)
                completion(updatedTodo, null)
            } catch (e: Exception) {
                completion(null, e)
            }
        }
    }

    // Method to update the title of a todo
    fun updateTodoTitle(todo: Todo, newTitle: String, completion: (Todo?, Exception?) -> Unit) {
        scope.launch {
            try {
                val updatedTodo = repository.updateTodoTitle(todo, newTitle)
                completion(updatedTodo, null)
            } catch (e: Exception) {
                completion(null, e)
            }
        }
    }
}