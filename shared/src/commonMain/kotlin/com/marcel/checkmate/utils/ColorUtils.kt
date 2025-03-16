package com.marcel.checkmate.utils

import kotlin.math.roundToInt

/**
 * Utility class for color-related operations in Checkmate app
 */
object ColorUtils {
    /**
     * Converts a hex color string to an ARGB Long value
     * @param hex Hex color string (with or without # prefix)
     * @return Long representation of the color
     */
    fun parseHexColor(hex: String): Long {
        val cleanHex = hex.trimStart('#')
        return when (cleanHex.length) {
            3 -> { // RGB (12-bit)
                val r = cleanHex[0].toString().repeat(2).toLong(16)
                val g = cleanHex[1].toString().repeat(2).toLong(16)
                val b = cleanHex[2].toString().repeat(2).toLong(16)
                0xFF000000L or (r shl 16) or (g shl 8) or b
            }
            6 -> { // RGB (24-bit)
                0xFF000000L or cleanHex.toLong(16)
            }
            8 -> { // ARGB (32-bit)
                cleanHex.toLong(16)
            }
            else -> 0xFF000000L // Default to black with full opacity
        }
    }

    /**
     * Predefined colors for the Checkmate app
     */
    object Colors {
        val PrimaryGreen = parseHexColor("#2E8B57")     // Sea Green
        val SecondaryGreen = parseHexColor("#98FB98")   // Pale Green
        val AccentGreen = parseHexColor("#3CB371")      // Medium Sea Green

        // You can add more colors here as needed
    }

    /**
     * Adjusts the opacity of a color
     * @param color Original color as Long
     * @param opacity Opacity value between 0.0 and 1.0
     * @return Color with adjusted opacity
     */
    fun withOpacity(color: Long, opacity: Float): Long {
        val opacityInt = (opacity.coerceIn(0f, 1f) * 255).roundToInt().toLong()
        return (color and 0x00FFFFFF) or (opacityInt shl 24)
    }
}