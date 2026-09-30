package com.danfe.restroorder.waiter.ui.shift

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.TableRow
import com.danfe.restroorder.waiter.ui.login.AppVMFactory

/**
 * Target-table picker for "shift table" and "shift items" (old TableSelectionActivity /
 * ItemShiftActivity). The caller supplies the PIN via PinDialog before invoking
 * vm.shiftTable / vm.shiftItems — same gating order as the old app.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ShiftScreen(
    source: TableRow,
    mode: String, // "table" | "items"
    onBack: () -> Unit,
    requestPin: (onOk: (String) -> Unit) -> Unit,
) {
    val app = LocalContext.current.applicationContext as App
    val vm: ShiftViewModel = viewModel(factory = AppVMFactory(app) { ShiftViewModel(app) })
    val ui by vm.ui.collectAsState()

    LaunchedEffect(Unit) {
        vm.init(source)
        if (mode == "items") vm.loadSourceLines()
    }

    LaunchedEffect(ui.done) { if (ui.done) onBack() }

    Scaffold(topBar = {
        TopAppBar(
            title = { Text(if (mode == "items") "Shift items from ${source.tableTitle ?: ""}" else "Shift ${source.tableTitle ?: ""} to…") },
            navigationIcon = { TextButton(onClick = onBack) { Text("← Back") } },
        )
    }) { pad ->
        Column(Modifier.fillMaxSize().padding(pad)) {
            if (ui.busy) LinearProgressIndicator(Modifier.fillMaxWidth())
            ui.error?.let {
                Text(it, color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(horizontal = 16.dp))
            }
            ui.info?.let {
                Text(it, color = MaterialTheme.colorScheme.primary, modifier = Modifier.padding(horizontal = 16.dp))
            }

            if (mode == "items") {
                Text("Select items to move", style = MaterialTheme.typography.titleMedium,
                    modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp))
                ui.sourceLines.forEach { l ->
                    Row(verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier.padding(horizontal = 12.dp)) {
                        Checkbox(
                            checked = l.itemId in ui.selectedKeys,
                            onCheckedChange = { vm.toggleLine(l.itemId) },
                        )
                        Text("${l.title} × ${l.quantity}")
                    }
                }
                Spacer(Modifier.height(8.dp))
            }

            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(horizontal = 12.dp)) {
                items(ui.roomTypes) { t ->
                    FilterChip(
                        selected = t.roomTypeId == ui.selectedTypeId,
                        onClick = { vm.selectType(t.roomTypeId ?: "") },
                        label = { Text(t.title ?: "—") },
                    )
                }
            }
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(horizontal = 12.dp, vertical = 8.dp)) {
                items(ui.rooms) { r ->
                    FilterChip(
                        selected = r.roomId == ui.selectedRoomId,
                        onClick = { vm.selectRoom(r.roomId ?: "") },
                        label = { Text(r.roomName ?: "—") },
                    )
                }
            }

            LazyColumn(contentPadding = PaddingValues(12.dp)) {
                items(ui.targets) { t ->
                    val suggested = t.statusId?.toString()?.trim('"') == "6" // valid shift target per old app (UNKNOWN semantics)
                    Card(
                        modifier = Modifier.fillMaxWidth().padding(vertical = 5.dp),
                        onClick = {
                            requestPin { pin ->
                                if (mode == "items") vm.shiftItems(t, pin) else vm.shiftTable(t, pin)
                            }
                        },
                    ) {
                        Row(Modifier.padding(14.dp), verticalAlignment = Alignment.CenterVertically) {
                            Text(t.tableTitle ?: "—", style = MaterialTheme.typography.titleMedium,
                                modifier = Modifier.weight(1f))
                            if (suggested) AssistChip(onClick = {}, label = { Text("Free") })
                            Text("Go →", color = MaterialTheme.colorScheme.primary)
                        }
                    }
                }
            }
        }
    }
}
