package com.danfe.restroorder.waiter.ui.bill

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.TableRow
import com.danfe.restroorder.waiter.data.repository.AuthRepository
import com.danfe.restroorder.waiter.data.repository.OrderRepository

/**
 * Bill preview (old ShowBillActivity): built from the UpdateOrder snapshot, display only.
 * The old app never printed from here — printing stays server-side (answer #1), so this screen
 * is read-only by design.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ShowBillScreen(table: TableRow, onBack: () -> Unit) {
    val app = LocalContext.current.applicationContext as App
    val orders = remember { OrderRepository(app, app.session) }
    var lines by remember { mutableStateOf<List<com.danfe.restroorder.waiter.data.model.OrderDetail>?>(null) }
    var total by remember { mutableStateOf<Double?>(null) }
    var error by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(Unit) {
        try {
            val snap = orders.updateOrder(table.tableId ?: "")
            lines = snap?.orderDetailsList ?: emptyList()
            total = snap?.orderDetailsList?.sumOf { d ->
                val rate = (d.rate as? Number)?.toDouble() ?: d.rate?.toString()?.toDoubleOrNull() ?: 0.0
                val qty = (d.quantity as? Number)?.toDouble() ?: d.quantity?.toString()?.toDoubleOrNull() ?: 0.0
                val extra = d.extraCharge?.toString()?.toDoubleOrNull() ?: 0.0
                rate * qty + extra
            }
        } catch (e: Exception) {
            error = AuthRepository.friendly(e)
        }
    }

    Scaffold(topBar = {
        TopAppBar(
            title = { Text("Bill — ${table.tableTitle ?: ""}") },
            navigationIcon = { TextButton(onClick = onBack) { Text("← Back") } },
        )
    }) { pad ->
        Column(Modifier.fillMaxSize().padding(pad)) {
            error?.let { Text(it, color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(16.dp)) }
            if (lines == null && error == null) LinearProgressIndicator(Modifier.fillMaxWidth())
            LazyColumn(Modifier.weight(1f), contentPadding = PaddingValues(16.dp)) {
                items(lines ?: emptyList()) { d ->
                    Row(Modifier.fillMaxWidth().padding(vertical = 6.dp), verticalAlignment = Alignment.CenterVertically) {
                        Text("${d.quantity} ×", style = MaterialTheme.typography.titleMedium, modifier = Modifier.width(48.dp))
                        Text(d.itemName ?: "—", modifier = Modifier.weight(1f))
                        Text("${d.rate}", style = MaterialTheme.typography.bodyLarge)
                    }
                    d.note?.takeIf { it.isNotBlank() }?.let {
                        Text("   note: $it", style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                }
            }
            HorizontalDivider()
            Row(Modifier.fillMaxWidth().padding(16.dp)) {
                Text("Total", style = MaterialTheme.typography.titleLarge, modifier = Modifier.weight(1f))
                Text(total?.let { "%.2f".format(it) } ?: "—", style = MaterialTheme.typography.titleLarge)
            }
            Text(
                "Printing happens on the POS server. This preview is computed on-device for display only.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
            )
        }
    }
}
