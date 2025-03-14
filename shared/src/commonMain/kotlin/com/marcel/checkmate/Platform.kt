package com.marcel.checkmate

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform