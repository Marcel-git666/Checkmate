package com.marcel.checkmate.repository

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
    }

    suspend fun fetchTodos(): List<Todo> {
        return client.get("https://jsonplaceholder.typicode.com/todos").body()
    }

    suspend fun fetchTodo(id: Int): Todo {
        return client.get("https://jsonplaceholder.typicode.com/todos/$id").body()
    }

    suspend fun toggleTodoCompletion(todo: Todo): Todo {
        val updatedTodo = todo.copy(completed = !todo.completed)

        return client.put("https://jsonplaceholder.typicode.com/todos/${todo.id}") {
            contentType(ContentType.Application.Json)
            setBody(updatedTodo)
        }.body()
    }

    suspend fun updateTodoTitle(todo: Todo, newTitle: String): Todo {
        val updatedTodo = todo.copy(title = newTitle)

        return client.put("https://jsonplaceholder.typicode.com/todos/${todo.id}") {
            contentType(ContentType.Application.Json)
            setBody(updatedTodo)
        }.body()
    }
}


