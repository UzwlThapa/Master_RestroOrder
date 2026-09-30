package com.danfe.restroorder.waiter.ui.log

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.danfe.restroorder.waiter.data.api.ApiFactory

/**
 * In-app HTTP debug log (answer #20/21): shows the last requests/responses captured by the
 * OkHttp logging interceptor so waiters can export logs when testing against a real server.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DebugLogScreen(onBack: () -> Unit) {
    val lines by ApiFactory.httpLog.flow.collectAsState()
    val clipboard = LocalClipboardManager.current

    Scaffold(topBar = {
        TopAppBar(
            title = { Text("Debug log (${lines.size})") },
            navigationIcon = { TextButton(onClick = onBack) { Text("← Back") } },
            actions = {
                TextButton(onClick = { clipboard.setText(AnnotatedString(lines.joinToString("\n"))) }) { Text("Copy") }
                TextButton(onClick = { ApiFactory.httpLog.clear() }) { Text("Clear") }
            },
        )
    }) { pad ->
        LazyColumn(Modifier.fillMaxSize().padding(pad), contentPadding = PaddingValues(12.dp)) {
            items(lines.asReversed()) { line ->
                Text(line, fontSize = 11.sp, modifier = Modifier.padding(vertical = 2.dp))
            }
        }
    }
}
