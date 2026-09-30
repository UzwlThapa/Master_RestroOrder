package com.danfe.restroorder.waiter.ui.common

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

/**
 * 4-digit PIN gate used before send / cancel / pay / table shift / item shift,
 * exactly like helper/CheckPinCode.java in the old app. Auto-submits at 4 digits
 * (same behaviour as the login PIN pad); the server-side CheckPin call still validates it.
 */
@Composable
fun PinDialog(
    title: String,
    onDismiss: () -> Unit,
    onSubmit: (String) -> Unit,
) {
    var pin by rememberSaveable { mutableStateOf("") }

    fun press(k: String) {
        when (k) {
            "OK" -> if (pin.length == 4) onSubmit(pin)
            "⌫" -> pin = pin.dropLast(1)
            else -> if (pin.length < 4) {
                pin += k
                if (pin.length == 4) onSubmit(pin) // auto-submit at 4 digits
            }
        }
    }

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            Column(Modifier.fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp), modifier = Modifier.fillMaxWidth()) {
                    repeat(4) { i ->
                        Surface(
                            tonalElevation = 2.dp,
                            modifier = Modifier.weight(1f).height(56.dp),
                            shape = MaterialTheme.shapes.medium,
                        ) {
                            Box(contentAlignment = Alignment.Center) {
                                Text(if (i < pin.length) "•" else "", style = MaterialTheme.typography.headlineMedium)
                            }
                        }
                    }
                }
                val keys = listOf(
                    listOf("1", "2", "3"),
                    listOf("4", "5", "6"),
                    listOf("7", "8", "9"),
                    listOf("⌫", "0", "OK"),
                )
                keys.forEach { row ->
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.fillMaxWidth()) {
                        row.forEach { k ->
                            TextButton(
                                onClick = { press(k) },
                                modifier = Modifier.weight(1f).height(60.dp),
                            ) { Text(k, style = MaterialTheme.typography.headlineSmall) }
                        }
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { if (pin.length == 4) onSubmit(pin) }, enabled = pin.length == 4) { Text("OK") }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text("Cancel") } },
    )
}
