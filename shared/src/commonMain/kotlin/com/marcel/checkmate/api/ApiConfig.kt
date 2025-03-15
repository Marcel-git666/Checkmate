package com.marcel.checkmate.api

object ApiConfig {
    const val BASE_URL = "https://jsonplaceholder.typicode.com"
    const val TODOS_ENDPOINT = "$BASE_URL/todos"

    fun todoUrl(id: Int) = "$TODOS_ENDPOINT/$id"
}