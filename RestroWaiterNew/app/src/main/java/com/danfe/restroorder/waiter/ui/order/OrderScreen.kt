package com.danfe.restroorder.waiter.ui.order

import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import coil.compose.AsyncImage
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.MenuItem
import com.danfe.restroorder.waiter.data.model.OrderExtraItem
import com.danfe.restroorder.waiter.data.repository.OrderRepository
import com.danfe.restroorder.waiter.ui.common.PinDialog
import com.danfe.restroorder.waiter.ui.login.AppVMFactory
import com.danfe.restroorder.waiter.util.AutoLogout

/**
 * Ordering screen: category chips + search on top, big item cards, always-visible bottom bar with
 * running total and Send. Summary sheet shows lines with +/- qty, notes, seat, remove, split and
 * per-cost-centre discounts (display only — never sent, exactly like the old app).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OrderScreen(
    tableId: String,
    orderMasterId: String,
    roomId: String? = null,
    onBack: () -> Unit,
    onLogout: () -> Unit,
) {
    val app = LocalContext.current.applicationContext as App
    val vm: OrderViewModel = viewModel(factory = AppVMFactory(app) { OrderViewModel(app) })
    val ui by vm.ui.collectAsState()
    AutoLogout.touch()

    LaunchedEffect(tableId) { vm.open(tableId, orderMasterId, roomId) }

    var pinDialog by remember { mutableStateOf<String?>(null) }   // "send" | "cancel" | "pay"
    var detailItem by remember { mutableStateOf<MenuItem?>(null) }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Table $tableId") },
                navigationIcon = { TextButton(onClick = onBack) { Text("← Tables") } },
                actions = {
                    TextButton(onClick = { pinDialog = "cancel" }) { Text("Cancel") }
                    TextButton(onClick = onLogout) { Text("Logout") }
                },
            )
        },
        bottomBar = {
            // Running summary always visible (requirement)
            Surface(tonalElevation = 6.dp) {
                Row(
                    Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 10.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                ) {
                    Column(Modifier.weight(1f)) {
                        Text("Total: ${ui.lines.sumOf { it.qty }} items", style = MaterialTheme.typography.labelLarge)
                        Text("Rs. ${"%.2f".format(vm.displayTotal())}", style = MaterialTheme.typography.titleLarge)
                    }
                    OutlinedButton(onClick = vm::toggleSummary) { Text("Summary") }
                    Button(
                        onClick = { pinDialog = "send" },
                        enabled = !ui.busy && ui.lines.any { it.existingOrderDetailsId == null },
                        modifier = Modifier.height(52.dp).widthIn(min = 120.dp),
                    ) { Text("Send") }
                }
            }
        },
    ) { pad ->
        Column(Modifier.fillMaxSize().padding(pad)) {
            OutlinedTextField(
                value = ui.search, onValueChange = vm::setSearch,
                label = { Text("Search menu") }, singleLine = true,
                modifier = Modifier.fillMaxWidth().padding(horizontal = 12.dp, vertical = 6.dp),
            )
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp), modifier = Modifier.padding(horizontal = 12.dp)) {
                items(ui.categories) { c ->
                    FilterChip(
                        selected = c.itemId == ui.selectedCategory,
                        onClick = { vm.selectCategory(c.itemId) },
                        label = { Text(c.itemName ?: "—") },
                    )
                }
            }
            ui.error?.let {
                Text(it, color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(horizontal = 16.dp, vertical = 4.dp))
            }
            ui.sendResult?.let {
                Snackbar(modifier = Modifier.padding(8.dp)) { Text(it) }
                LaunchedEffect(it) { vm.consumeResult() }
            }
            if (ui.busy) LinearProgressIndicator(Modifier.fillMaxWidth())

            LazyColumn(contentPadding = PaddingValues(12.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                items(vm.visibleItems()) { m ->
                    ItemCard(
                        item = m,
                        inCartQty = ui.lines.filter { it.itemId == m.itemId && it.existingOrderDetailsId == null }.sumOf { it.qty },
                        onAdd = { vm.addItem(m) },
                        onLongPress = { detailItem = m },
                        imageUrl = m.imagePath?.takeIf { it.isNotBlank() }?.let { OrderRepository(app, app.session).imageUrl(it) },
                    )
                }
            }
        }
    }

    // ---- summary bottom sheet ----
    if (ui.showSummary) {
        ModalBottomSheet(onDismissRequest = vm::toggleSummary) {
            SummarySheet(vm = vm, ui = ui, onPay = { pinDialog = "pay" })
        }
    }

    // ---- PIN dialogs ----
    pinDialog?.let { purpose ->
        PinDialog(
            title = when (purpose) {
                "send" -> "PIN to send order"
                "cancel" -> "PIN to cancel order"
                else -> "PIN for bill/payment"
            },
            onDismiss = { pinDialog = null },
            onSubmit = { pin ->
                pinDialog = null
                when (purpose) {
                    "send" -> vm.send(pin)
                    "pay" -> vm.pay(pin)
                    "cancel" -> vm.cancelOrder(pin, reason = "Cancelled from waiter app", cancelBy = app.session.state.value.username)
                }
            },
        )
    }

    // ---- item detail / extras dialog ----
    detailItem?.let { m ->
        ItemDetailDialog(
            item = m,
            onDismiss = { detailItem = null },
            onAddWithExtras = { extras -> vm.addItem(m, extras); detailItem = null },
        )
    }
}

@Composable
private fun ItemCard(item: MenuItem, inCartQty: Int, onAdd: () -> Unit, onLongPress: () -> Unit, imageUrl: String?) {
    Card(
        onClick = onLongPress,
        modifier = Modifier.fillMaxWidth(),
        interactionSource = remember { MutableInteractionSource() },
    ) {
        Row(Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            if (imageUrl != null) {
                AsyncImage(model = imageUrl, contentDescription = null,
                    modifier = Modifier.size(56.dp), )
                Spacer(Modifier.width(12.dp))
            }
            Column(Modifier.weight(1f)) {
                Text(item.itemName ?: "—", style = MaterialTheme.typography.titleMedium)
                Text("${item.currency ?: ""} ${item.sRate ?: ""}".trim(), style = MaterialTheme.typography.bodyMedium)
                if (item.isCombo == true) Text("Combo", style = MaterialTheme.typography.labelSmall)
            }
            if (item.isOutOfStock == true) {
                AssistChip(onClick = {}, label = { Text("Out of stock") })
            } else {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Button(onClick = onAdd, modifier = Modifier.height(56.dp).widthIn(min = 72.dp)) {
                        Text(if (inCartQty > 0) "+ ($inCartQty)" else "+")
                    }
                }
            }
        }
    }
}

@Composable
private fun SummarySheet(vm: OrderViewModel, ui: OrderViewModel.Ui, onPay: () -> Unit) {
    val flags = ui.featureFlags
    Column(Modifier.padding(horizontal = 16.dp).padding(bottom = 24.dp)) {
        Text("Order summary", style = MaterialTheme.typography.titleLarge)
        Row(verticalAlignment = Alignment.CenterVertically) {
            if (flags.splitBill) {
                Checkbox(checked = ui.isSplit, onCheckedChange = { vm.toggleSplit() })
                Text("Split bill")
                Spacer(Modifier.width(12.dp))
                OutlinedTextField(
                    value = ui.guestNo, onValueChange = vm::setGuestNo, label = { Text("Guests") },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.width(110.dp), singleLine = true,
                )
            }
        }
        LazyColumn {
            items(ui.lines) { l ->
                Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(vertical = 6.dp)) {
                    Column(Modifier.weight(1f)) {
                        Text(l.title + if (l.existingOrderDetailsId != null) "  (sent)" else "", style = MaterialTheme.typography.bodyLarge)
                        if (l.note.isNotBlank()) Text("Note: ${l.note}", style = MaterialTheme.typography.bodySmall)
                        l.extras.forEach { e -> Text("+ ${e.extraItem}", style = MaterialTheme.typography.bodySmall) }
                        OutlinedTextField(
                            value = l.note, onValueChange = { vm.setNote(l.key, it) },
                            label = { Text("Note") }, modifier = Modifier.fillMaxWidth().height(56.dp), singleLine = true,
                        )
                    }
                    if (l.existingOrderDetailsId == null) {
                        IconButton(onClick = { vm.changeQty(l.key, -1) }) { Text("−", style = MaterialTheme.typography.headlineMedium) }
                        Text("${l.qty}", style = MaterialTheme.typography.titleLarge)
                        IconButton(onClick = { vm.changeQty(l.key, +1) }) { Text("+", style = MaterialTheme.typography.headlineMedium) }
                        IconButton(onClick = { vm.removeLine(l.key) }) { Text("✕", color = MaterialTheme.colorScheme.error) }
                    } else {
                        Text("×${l.qty}", style = MaterialTheme.typography.titleMedium)
                    }
                }
            }
            if (flags.payBill) {
                item {
                    Spacer(Modifier.height(12.dp))
                    Button(onClick = onPay, modifier = Modifier.fillMaxWidth().height(52.dp)) { Text("Request bill / Pay") }
                }
            }
            // per-cost-centre discounts (display only)
            items(ui.costCenters) { cc ->
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(cc.name ?: "—", modifier = Modifier.weight(1f))
                    OutlinedTextField(
                        value = (ui.discounts[cc.id ?: ""] ?: 0.0).toString(),
                        onValueChange = { v -> vm.setDiscount(cc.id ?: "", v.toDoubleOrNull() ?: 0.0) },
                        label = { Text("% disc") }, modifier = Modifier.width(120.dp), singleLine = true,
                    )
                }
            }
        }
    }
}

@Composable
private fun ItemDetailDialog(item: MenuItem, onDismiss: () -> Unit, onAddWithExtras: (List<OrderExtraItem>) -> Unit) {
    val selected = remember { mutableStateListOf<String>() }
    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(item.itemName ?: "") },
        text = {
            Column {
                item.details?.let { Text(it) ; Spacer(Modifier.height(8.dp)) }
                item.extradata?.forEach { ex ->
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Checkbox(checked = ex.extraItemId in selected, onCheckedChange = { on ->
                            if (on) selected.add(ex.extraItemId ?: "") else selected.remove(ex.extraItemId)
                        })
                        Text("${ex.extraItem} (+${ex.extraPrice})", modifier = Modifier.weight(1f))
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = {
                val extras = (item.extradata ?: emptyList()).filter { it.extraItemId in selected }.map {
                    OrderExtraItem(
                        itemId = item.itemId, extraItemId = it.extraItemId, extraItem = it.extraItem,
                        extraPrice = it.extraPrice, quantity = 1, seatNo = "1",
                    )
                }
                onAddWithExtras(extras)
            }) { Text("Add") }
        },
        dismissButton = { TextButton(onClick = onDismiss) { Text("Close") } },
    )
}
