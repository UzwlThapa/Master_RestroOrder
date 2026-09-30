package com.danfe.restroorder.waiter.ui.order

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.CostCenter
import com.danfe.restroorder.waiter.data.model.MenuItem
import com.danfe.restroorder.waiter.data.model.OrderExtraItem
import com.danfe.restroorder.waiter.data.repository.AuthRepository
import com.danfe.restroorder.waiter.data.repository.OrderRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

/**
 * Ordering screen (old MainActivity + MenuItemFragment).
 * Tabs Ordered / InProgress / Complete come from OrderDetail.Status, exactly as before.
 * Draft lines are merged with the server snapshot; nothing is sent until Send (PIN-gated),
 * mirroring the old app's flow. Totals/discounts are computed on-device for display only.
 */
class OrderViewModel(private val app: App) : ViewModel() {

    private val orders = OrderRepository(app, app.session)
    private val auth = AuthRepository(app, app.session)

    data class Line(
        val key: String,                       // itemId + extras signature
        val itemId: String,
        val title: String,
        val rate: Double,
        var qty: Int,
        val existingOrderDetailsId: String?,   // null => new, will be sent as ""
        var note: String,
        val isCombo: Boolean,
        var seatNo: String,
        val extras: List<OrderExtraItem>,
        val status: String?,                   // server status for tabbing existing rows
        val costCenterId: String?,
    )

    data class Ui(
        val busy: Boolean = false,
        val error: String? = null,
        val info: String? = null,
        val menu: List<MenuItem> = emptyList(),
        val categories: List<MenuItem> = emptyList(),
        val selectedCategory: String? = null,
        val search: String = "",
        val lines: MutableList<Line> = mutableListOf(),
        val orderMasterId: String = "",
        val isSplit: Boolean = false,
        val guestNo: String = "1",
        val seatNo: String = "1",
        val costCenters: List<CostCenter> = emptyList(),
        val discounts: MutableMap<String, Double> = mutableMapOf(), // per cost center %
        val showSummary: Boolean = false,
        val sendResult: String? = null,
        val featureFlags: com.danfe.restroorder.waiter.data.local.FeatureFlags = com.danfe.restroorder.waiter.data.local.FeatureFlags(),
    )

    private val _ui = MutableStateFlow(Ui())
    val ui: StateFlow<Ui> = _ui

    var tableId: String = ""
    var roomId: String? = null

    fun open(tableId: String, initialOrderMasterId: String, roomId: String? = null) {
        this.tableId = tableId
        this.roomId = roomId
        viewModelScope.launch {
            _ui.value = _ui.value.copy(busy = true, error = null)
            try {
                val menu = orders.loadMenu()
                val cats = menu.filter { it.isCategory == true }
                val snapshot = orders.updateOrder(tableId, roomId)
                val serverLines = snapshot?.orderDetailsList?.map { d ->
                    Line(
                        key = "${d.itemId}-${d.orderDetailsId}",
                        itemId = d.itemId ?: "",
                        title = d.itemName ?: "",
                        rate = d.rate.asDouble(),
                        qty = d.quantity.asInt(1),
                        existingOrderDetailsId = d.orderDetailsId,
                        note = d.note ?: "",
                        isCombo = d.isCombo == true,
                        seatNo = d.seatNo.asString("1"),
                        extras = d.orderExtraItem ?: emptyList(),
                        status = d.status,
                        costCenterId = d.costCenterId,
                    )
                }?.toMutableList() ?: mutableListOf()
                _ui.value = _ui.value.copy(
                    busy = false,
                    menu = menu,
                    categories = cats,
                    selectedCategory = cats.firstOrNull()?.itemId,
                    lines = serverLines,
                    orderMasterId = snapshot?.orderMasterId ?: initialOrderMasterId,
                    isSplit = snapshot?.isSplit == true,
                    guestNo = snapshot?.guestNo.asString("1"),
                    featureFlags = app.session.state.value.featureFlags,
                )
                loadCostCenters()
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(busy = false, error = AuthRepository.friendly(e))
            }
        }
    }

    private suspend fun loadCostCenters() {
        runCatching { auth.activeBillTerm().d?.costCenter }
            .onSuccess { _ui.value = _ui.value.copy(costCenters = it ?: emptyList()) }
    }

    fun visibleItems(): List<MenuItem> {
        val u = _ui.value
        val q = u.search.trim().lowercase()
        return u.menu.filter { it.isCategory != true }.filter { m ->
            if (q.isNotEmpty()) {
                (m.itemCode?.lowercase()?.contains(q) == true) || (m.itemName?.lowercase()?.contains(q) == true)
            } else (m.pItemId == u.selectedCategory || u.selectedCategory == null)
        }
    }

    fun selectCategory(id: String?) { _ui.value = _ui.value.copy(selectedCategory = id) }
    fun setSearch(s: String) { _ui.value = _ui.value.copy(search = s) }

    fun addItem(m: MenuItem, extras: List<OrderExtraItem> = emptyList()) {
        if (m.isOutOfStock == true) {
            _ui.value = _ui.value.copy(error = "${m.itemName} is out of stock")
            return
        }
        val lines = _ui.value.lines.toMutableList()
        val key = m.itemId + "|" + extras.joinToString(",") { it.extraItemId ?: "" }
        val existing = lines.firstOrNull { it.key == key && it.existingOrderDetailsId == null }
        if (existing != null) existing.qty += 1
        else lines.add(
            Line(
                key = key, itemId = m.itemId ?: "", title = m.itemName ?: "",
                rate = m.sRate.asDouble(), qty = 1, existingOrderDetailsId = null,
                note = "", isCombo = m.isCombo == true, seatNo = _ui.value.seatNo,
                extras = extras, status = null, costCenterId = m.costCenterId,
            )
        )
        _ui.value = _ui.value.copy(lines = lines)
    }

    fun changeQty(key: String, delta: Int) {
        val lines = _ui.value.lines.toMutableList()
        val l = lines.firstOrNull { it.key == key } ?: return
        // Existing server rows are not edited in place — like the old app, quantity changes on a
        // sent row create a fresh unsent line rather than mutating the kitchen ticket.
        val target = if (l.existingOrderDetailsId != null && delta > 0) {
            val copy = l.copy(key = l.key + "#new${lines.size}", existingOrderDetailsId = null, qty = 0, status = null)
            lines.add(copy); copy
        } else l
        target.qty += delta
        if (target.qty <= 0 && target.existingOrderDetailsId == null) lines.remove(target)
        _ui.value = _ui.value.copy(lines = lines)
    }

    fun setNote(key: String, note: String) {
        _ui.value.lines.firstOrNull { it.key == key }?.note = note
        _ui.value = _ui.value.copy()
    }

    fun setSeat(key: String, seat: String) {
        _ui.value.lines.firstOrNull { it.key == key }?.seatNo = seat
        _ui.value = _ui.value.copy()
    }

    fun removeLine(key: String) {
        val lines = _ui.value.lines.toMutableList()
        lines.removeAll { it.key == key && it.existingOrderDetailsId == null }
        _ui.value = _ui.value.copy(lines = lines)
    }

    fun toggleSplit() { _ui.value = _ui.value.copy(isSplit = !_ui.value.isSplit) }
    fun setGuestNo(v: String) { _ui.value = _ui.value.copy(guestNo = v) }
    fun setSeatNo(v: String) { _ui.value = _ui.value.copy(seatNo = v) }
    fun setDiscount(costCenterId: String, pct: Double) {
        val map = _ui.value.discounts.toMutableMap(); map[costCenterId] = pct
        _ui.value = _ui.value.copy(discounts = map)
    }
    fun toggleSummary() { _ui.value = _ui.value.copy(showSummary = !_ui.value.showSummary) }
    fun consumeResult() { _ui.value = _ui.value.copy(sendResult = null, info = null) }

    /** Running total for display only (never sent), with per-cost-center discounts applied. */
    fun displayTotal(): Double {
        val u = _ui.value
        val byCc = u.lines.groupBy { it.costCenterId ?: "" }
        return byCc.entries.sumOf { (cc, lines) ->
            val sub = lines.sumOf { it.rate * it.qty + it.extras.sumOf { e -> e.extraPrice.asDouble() * e.qtyOrOne() } }
            val disc = u.discounts[cc] ?: 0.0
            sub * (1 - disc / 100.0)
        }
    }

    private fun OrderExtraItem.qtyOrOne(): Int = (quantity as? Number)?.toInt() ?: quantity?.toString()?.toIntOrNull() ?: 1

    /**
     * Send: CheckPin first (kept from the old app — the returned UserName goes into PurchaseOrder),
     * then PurchaseOrder. statusCode 200 == success; message may be "\"Printing Failed\"" which we
     * surface verbatim because printing is server-side (answer #1).
     */
    fun send(pin: String) {
        val u = _ui.value
        viewModelScope.launch {
            _ui.value = _ui.value.copy(busy = true, error = null)
            try {
                val pinResp = auth.checkPin(pin)
                val pinUser = pinResp.data?.userName
                if (pinUser.isNullOrBlank()) {
                    _ui.value = _ui.value.copy(busy = false, error = pinResp.message ?: "Wrong PIN")
                    return@launch
                }
                val drafts = u.lines.map { l ->
                    OrderRepository.DraftLine(
                        itemId = l.itemId, title = l.title, quantity = l.qty,
                        existingOrderDetailsId = l.existingOrderDetailsId,
                        note = l.note, isCombo = l.isCombo, seatNo = l.seatNo, extras = l.extras,
                    )
                }
                val resp = orders.sendOrder(
                    orderMasterId = u.orderMasterId, tableId = tableId, roomId = roomId,
                    isSplit = u.isSplit, guestNo = u.guestNo, seatNo = u.seatNo,
                    pinUserName = pinUser, lines = drafts,
                )
                val code = resp.statusCode?.toString()?.trim('"')
                val msg = resp.message ?: ""
                _ui.value = _ui.value.copy(
                    busy = false,
                    sendResult = when {
                        code == "200" && msg.contains("Printing Failed") ->
                            "Order sent, but the server reported: $msg"
                        code == "200" -> "Order sent"
                        else -> "Server said: ${msg.ifBlank { "code $code" }}"
                    },
                )
                if (code == "200") open(tableId, u.orderMasterId)
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(busy = false, error = AuthRepository.friendly(e))
            }
        }
    }

    /** Cancel whole order — requires role Void Bill + PIN, same as the old app. */
    fun cancelOrder(pin: String, reason: String, cancelBy: String) {
        viewModelScope.launch {
            _ui.value = _ui.value.copy(busy = true, error = null)
            try {
                val roles = app.session.state.value.roles.orEmpty()
                if (!roles.contains("Void Bill")) {
                    _ui.value = _ui.value.copy(busy = false, error = "Your role cannot cancel bills (needs \"Void Bill\").")
                    return@launch
                }
                val pinResp = auth.checkPin(pin)
                val pinUser = pinResp.data?.userName ?: run {
                    _ui.value = _ui.value.copy(busy = false, error = pinResp.message ?: "Wrong PIN"); return@launch
                }
                val u = _ui.value
                val cancelledItems = u.lines.map {
                    mapOf(
                        "Item" to it.title, "Quantity" to it.qty, "OrderBy" to u.orderMasterId,
                        "CanceledBy" to cancelBy, "Reason" to reason, "Responsible" to cancelBy,
                        "tableId" to tableId, "SeatNo" to it.seatNo, "orderMasterID" to u.orderMasterId,
                    )
                }
                val resp = orders.cancelOrder(u.orderMasterId, tableId, reason, u.guestNo, u.seatNo, cancelBy, pinUser)
                val msg = resp.message?.trim('"').orEmpty()
                if (msg.contains("Print Failed.")) {
                    _ui.value = _ui.value.copy(info = "Cancelled, but server reported: $msg")
                }
                orders.saveCanceledItems(cancelledItems)
                _ui.value = _ui.value.copy(busy = false, sendResult = "Order cancelled")
                open(tableId, "")
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(busy = false, error = AuthRepository.friendly(e))
            }
        }
    }

    fun pay(pin: String) {
        viewModelScope.launch {
            try {
                val pinResp = auth.checkPin(pin)
                if (pinResp.data?.userName.isNullOrBlank()) {
                    _ui.value = _ui.value.copy(error = pinResp.message ?: "Wrong PIN"); return@launch
                }
                val resp = orders.pay(tableId)
                val st = resp.status?.trim('"')
                _ui.value = _ui.value.copy(sendResult = if (st == "Success") "Bill sent to payment" else "Pay failed: $st")
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = AuthRepository.friendly(e))
            }
        }
    }

    fun toggleStock(itemId: String, onToggleDone: () -> Unit) {
        viewModelScope.launch {
            try {
                orders.toggleOutOfStock(itemId) // request identical; server toggles (UNKNOWN exact semantics)
                menuCacheBust()
                onToggleDone()
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = AuthRepository.friendly(e))
            }
        }
    }

    private suspend fun menuCacheBust() { orders.loadMenu(forceRefresh = true).let { fresh ->
        _ui.value = _ui.value.copy(menu = fresh, categories = fresh.filter { it.isCategory == true })
    } }

    companion object {
        fun Any?.asDouble(): Double = (this as? Number)?.toDouble() ?: toString()?.toDoubleOrNull() ?: 0.0
        fun Any?.asInt(def: Int): Int = (this as? Number)?.toInt() ?: toString()?.toIntOrNull() ?: def
        fun Any?.asString(def: String): String = this?.toString()?.trim('"')?.ifBlank { def } ?: def
    }
}
