package com.danfe.restroorder.waiter.ui.tables

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.TableRow
import com.danfe.restroorder.waiter.ui.login.AppVMFactory
import com.danfe.restroorder.waiter.util.AutoLogout

/**
 * Table grid screen. Tap a table to open ordering; long-press for shift/merge/show-bill actions.
 * Status colours: free / occupied(status 7) / pending bill(status 5) / paid / cancelled — values
 * inferred from the old app, so we render them as neutral chips with text too
 * (UNKNOWN semantics preserved conservatively).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TablesScreen(
    onOpenTable: (tableId: String, orderMasterId: String) -> Unit,
    onShiftTable: (TableRow) -> Unit,
    onShiftItems: (TableRow) -> Unit,
    onShowBill: (TableRow) -> Unit,
    onLogout: () -> Unit,
    onOpenSettings: () -> Unit,
) {
    val app = LocalContext.current.applicationContext as App
    val vm: TablesViewModel = viewModel(factory = AppVMFactory(app) { TablesViewModel(app) })
    val ui by vm.ui.collectAsState()
    AutoLogout.touch()

    var menuTable by remember { mutableStateOf<TableRow?>(null) }

    Scaffold(topBar = {
        TopAppBar(
            title = { Text("Tables") },
            actions = {
                if (ui.mergeMode) {
                    TextButton(onClick = vm::toggleMergeMode) { Text("Cancel merge") }
                } else {
                    TextButton(onClick = vm::toggleMergeMode) { Text("Merge") }
                }
                TextButton(onClick = vm::toggleBillFilter) {
                    Text(if (ui.billFilterActive) "All tables" else "Pending bills")
                }
                IconButton(onClick = vm::refresh) { Text("⟳", style = MaterialTheme.typography.headlineSmall) }
                TextButton(onClick = onOpenSettings) { Text("Server") }
                TextButton(onClick = onLogout) { Text("Logout") }
            }
        )
    }) { pad ->
        Column(Modifier.fillMaxSize().padding(pad)) {
            // Room types
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(horizontal = 12.dp)) {
                items(ui.roomTypes) { t ->
                    FilterChip(
                        selected = t.roomTypeId == ui.selectedTypeId,
                        onClick = { vm.selectType(t.roomTypeId ?: "") },
                        label = { Text(t.title ?: "—") },
                    )
                }
            }
            Spacer(Modifier.height(8.dp))
            // Rooms
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(horizontal = 12.dp)) {
                items(ui.rooms) { r ->
                    FilterChip(
                        selected = r.roomId == ui.selectedRoomId,
                        onClick = { vm.selectRoom(r.roomId ?: "") },
                        label = { Text(r.roomName ?: "—") },
                    )
                }
            }
            Spacer(Modifier.height(8.dp))
            ui.error?.let {
                Text(it, color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(horizontal = 16.dp))
            }
            if (ui.busy) LinearProgressIndicator(Modifier.fillMaxWidth())

            // Table grid — large touch targets, readable status
            val shownTables = if (ui.billFilterActive) {
                ui.tables.filter { t -> t.tableId?.toString()?.trim('"') in ui.pendingBillOrderIds }
            } else ui.tables
            LazyColumn(contentPadding = PaddingValues(12.dp)) {
                val cols = 3
                shownTables.chunked(cols).forEach { rowTables ->
                    item {
                        Row(horizontalArrangement = Arrangement.spacedBy(10.dp), modifier = Modifier.fillMaxWidth()) {
                            rowTables.forEach { t ->
                                TableCard(
                                    table = t,
                                    pendingBill = t.tableId?.toString()?.trim('"') in ui.pendingBillOrderIds,
                                    selected = t.tableId in ui.mergeSelection,
                                    modifier = Modifier.weight(1f),
                                    onClick = { vm.onTableTap(t) { tab -> com.danfe.restroorder.waiter.ui.nav.NavPayload.currentRoomId = ui.selectedRoomId; onOpenTable(tab.tableId ?: "", tab.orderMasterId ?: "") } },
                                    onLongClick = { menuTable = t },
                                )
                            }
                            repeat(cols - rowTables.size) { Spacer(Modifier.weight(1f)) }
                        }
                    }
                    item { Spacer(Modifier.height(10.dp)) }
                }
            }
        }
    }

    menuTable?.let { t ->
        val flags = app.session.state.value.featureFlags
        AlertDialog(
            onDismissRequest = { menuTable = null },
            title = { Text(t.tableTitle ?: "Table") },
            text = {
                Column {
                    if (flags.shiftTable) ActionRow("Shift table") { menuTable = null; onShiftTable(t) }
                    if (flags.shiftItems) ActionRow("Shift items") { menuTable = null; onShiftItems(t) }
                    if (flags.showBill) ActionRow("Show bill") { menuTable = null; onShowBill(t) }
                    if (flags.unmergeTables && !t.mergeId.isNullOrBlank()) ActionRow("Unmerge") { menuTable = null; vm.unmerge(t.tableId ?: "") }
                }
            },
            confirmButton = { TextButton(onClick = { menuTable = null }) { Text("Close") } },
        )
    }
}

@Composable
private fun ActionRow(label: String, onClick: () -> Unit) {
    TextButton(onClick = onClick, modifier = Modifier.fillMaxWidth()) { Text(label) }
}

@OptIn(ExperimentalFoundationApi::class)
@Composable
private fun TableCard(table: TableRow, selected: Boolean, pendingBill: Boolean = false, modifier: Modifier = Modifier, onClick: () -> Unit, onLongClick: () -> Unit) {
    val status = table.statusId?.toString()?.trim('"')
    val container = when {
        selected -> MaterialTheme.colorScheme.primaryContainer
        status == "7" -> MaterialTheme.colorScheme.errorContainer
        status == "5" || pendingBill -> MaterialTheme.colorScheme.tertiaryContainer
        table.billPaid?.toString()?.trim('"').equals("true", true) -> MaterialTheme.colorScheme.secondaryContainer
        else -> MaterialTheme.colorScheme.surfaceVariant
    }
    Surface(
        color = container,
        shape = MaterialTheme.shapes.large,
        modifier = modifier
            .height(96.dp)
            .combinedClickable(onClick = onClick, onLongClick = onLongClick),
    ) {
        Column(Modifier.padding(10.dp), verticalArrangement = Arrangement.SpaceBetween) {
            Text(table.tableTitle ?: "—", style = MaterialTheme.typography.titleMedium)
            Text(
                when {
                    status == "7" -> "Occupied"
                    status == "6" -> "Reserved"
                    status == "5" || pendingBill -> "Pending Bill"
                    status.isNullOrEmpty() -> "Free"
                    else -> "Status $status"
                },
                style = MaterialTheme.typography.labelLarge,
            )
        }
    }
}
