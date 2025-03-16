package com.marcel.checkmate.repository

import com.marcel.checkmate.api.ApiConfig
import com.marcel.checkmate.model.Todo
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json


class TodoRepository {
    private val client = HttpClient {
        install(ContentNegotiation) {
            json(Json {
                ignoreUnknownKeys = true
                prettyPrint = true
                isLenient = true
            })
        }
        // Don't expect success - we'll handle errors manually
        expectSuccess = false
    }

    suspend fun fetchTodos(): List<Todo> {
        val response = client.get(ApiConfig.TODOS_ENDPOINT)
        if (!response.status.isSuccess()) {
            throw Exception("Failed to fetch todos: ${response.status}")
        }
        return response.body()
    }

    suspend fun fetchTodo(id: Int): Todo {
        val response = client.get(ApiConfig.todoUrl(id))
        if (!response.status.isSuccess()) {
            throw Exception("Failed to fetch todo with id $id: ${response.status}")
        }
        return response.body()
    }

    suspend fun createTodo(title: String, userId: Int): Todo {
        val newTodo = Todo(
            // The id will be assigned by the server, but JSONPlaceholder needs some value
            id = 0,
            title = title,
            completed = false,
            userId = userId
        )

        try {
            val response = client.post(ApiConfig.TODOS_ENDPOINT) {
                contentType(ContentType.Application.Json)
                setBody(newTodo)
            }

            if (!response.status.isSuccess()) {
                throw Exception("Failed to create todo: ${response.status}")
            }

            return response.body()
        } catch (e: Exception) {
            // If there's any problem, create a local todo with a mock ID
            // For a real app, you would handle this differently
            val randomId = kotlin.random.Random.nextInt(10000, Int.MAX_VALUE)
            return Todo(
                id = randomId, // Generate a unique ID
                title = title,
                completed = false,
                userId = userId
            )
        }
    }

    suspend fun toggleTodoCompletion(todo: Todo): Todo {
        val updatedTodo = todo.copy(completed = !todo.completed)

        try {
            val response = client.put(ApiConfig.todoUrl(todo.id)) {
                contentType(ContentType.Application.Json)
                setBody(updatedTodo)
            }

            // For JSONPlaceholder, non-existing resources return 500 errors
            // So we'll just return the locally updated todo
            if (!response.status.isSuccess()) {
                return updatedTodo
            }

            return try {
                response.body()
            } catch (e: Exception) {
                // If we can't parse the response, return the local update
                updatedTodo
            }
        } catch (e: Exception) {
            // If there's any problem, just return the locally updated todo
            return updatedTodo
        }
    }

    suspend fun updateTodoTitle(todo: Todo, newTitle: String): Todo {
        val updatedTodo = todo.copy(title = newTitle)

        try {
            val response = client.put(ApiConfig.todoUrl(todo.id)) {
                contentType(ContentType.Application.Json)
                setBody(updatedTodo)
            }

            // For JSONPlaceholder, non-existing resources return 500 errors
            // So we'll just return the locally updated todo
            if (!response.status.isSuccess()) {
                return updatedTodo
            }

            return try {
                response.body()
            } catch (e: Exception) {
                // If we can't parse the response, return the local update
                updatedTodo
            }
        } catch (e: Exception) {
            // If there's any problem, just return the locally updated todo
            return updatedTodo
        }
    }

    suspend fun deleteTodo(id: Int): Boolean {
        try {
            val response = client.delete(ApiConfig.todoUrl(id))
            return response.status.isSuccess()
        } catch (e: Exception) {
            // For a mock API, we'll pretend the delete worked
            return true
        }
    }
}