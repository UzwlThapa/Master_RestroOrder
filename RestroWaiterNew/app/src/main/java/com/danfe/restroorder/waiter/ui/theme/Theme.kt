package com.danfe.restroorder.waiter.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Typography
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

// Dark, high-contrast palette for low-light dining rooms (answer #17).
private val DarkColors = darkColorScheme(
    primary = Color(0xFFFFB300),          // amber — strong on dark
    onPrimary = Color(0xFF1A1400),
    secondary = Color(0xFF64B5F6),
    onSecondary = Color(0xFF00223B),
    background = Color(0xFF0F1115),
    onBackground = Color(0xFFECEFF4),
    surface = Color(0xFF171A20),
    onSurface = Color(0xFFECEFF4),
    surfaceVariant = Color(0xFF232830),
    onSurfaceVariant = Color(0xFFC7CCD6),
    error = Color(0xFFEF5350),
    onError = Color(0xFF300000),
)

@Composable
fun RestroWaiterTheme(content: @Composable () -> Unit) {
    // Intentionally always-dark: readable in low light regardless of system setting.
    MaterialTheme(
        colorScheme = DarkColors,
        typography = Typography(),
        content = content,
    )
}
