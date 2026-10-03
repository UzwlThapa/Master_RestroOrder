package com.danfe.restroorder.waiter.data.model

/**
 * Lenient readers for the legacy server's loose JSON values.
 *
 * The old ASMX endpoints (JavaScriptSerializer) emit numbers, JSON-quoted strings ("7"),
 * /Date(...)/ stamps and sometimes empty strings for the SAME field depending on the code path.
 * Gson types `Any?` fields accordingly (Double/String/null), so every consumer must go through
 * these helpers instead of blind casts — this is the single source of truth for value coercion.
 */
object JsonValues {

    fun Any?.asDouble(): Double = when (this) {
        is Number -> toDouble()
        is String -> trim('"').toDoubleOrNull() ?: 0.0
        else -> 0.0
    }

    fun Any?.asInt(def: Int = 0): Int = when (this) {
        is Number -> toInt()
        is String -> trim('"').toIntOrNull() ?: toDoubleOrNullCompat() ?: def
        else -> def
    }

    /** Unquotes + trims; null stays null. */
    fun Any?.asString(): String? = this?.toString()?.trim('"')?.trim()?.ifBlank { null }

    fun Any?.asStringOrBlank(): String = asString() ?: ""

    /** statusCode-style comparison that tolerates 200 vs "200" vs "\"200\"". */
    fun Any?.isCode(value: Int): Boolean = when (this) {
        is Number -> toInt() == value
        is String -> trim('"').trim().toIntOrNull() == value
        else -> false
    }

    private fun String.toDoubleOrNullCompat(): Double? = toDoubleOrNull()
}
