package com.danfe.restroorder.waiter.ui.shift

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.RoomTypeGroup
import com.danfe.restroorder.waiter.data.model.TableRow
import com.danfe.restroorder.waiter.data.repository.AuthRepository
import com.danfe.restroorder.waiter.data.repository.OrderRepository
import com.danfe.restroorder.waiter.data.repository.TableRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

/**
 * Shared logic for "shift table" (old TableSelectionActivity) and "shift items"
 * (old ItemShiftActivity). Flow preserved exactly:
 *  - shift table: checkOrder -> PIN -> TableTransfer
 *  - shift items: pick sent lines -> PIN -> POST /Services/.../shiftItems (base kept identical, answer #11)
 * Target tables come from the same room-type/room browse; status 6 was treated as a valid
 * shift target by the old app (semantics UNKNOWN — used only to highlight suggestions, never to block).
 */
class ShiftViewModel(private val app: App) : ViewModel() {

    private val tables = TableRepository(app, app.session)
    private val orders = OrderRepository(app, app.session)
    private val auth = AuthRepository(app, app.session)

    data class Ui(
        val busy: Boolean = false,
        val error: String? = null,
        val info: String? = null,
        val done: Boolean = false,
        val roomTypes: List<RoomTypeGroup> = emptyList(),
        val selectedTypeId: String? = null,
        val rooms: List<com.danfe.restroorder.waiter.data.model.RoomEntry> = emptyList(),
        val selectedRoomId: String? = null,
        val targets: List<TableRow> = emptyList(),
        // item-shift state
        val sourceLines: List<OrderRepository.DraftLine> = emptyList(),
        val selectedKeys: MutableSet<String> = mutableSetOf(),
    )

    private val _ui = MutableStateFlow(Ui())
    val ui: StateFlow<Ui> = _ui

    /** Source table info passed in from the tables screen long-press menu. */
    var fromTableId: String = ""
    var fromOrderMasterId: String = ""
    var fromSplitNo: String = "0"

    fun init(from: TableRow) {
        fromTableId = from.tableId ?: ""
        fromOrderMasterId = from.orderMasterId ?: ""
        viewModelScope.launch {
            try {
                val resp = tables.fullRoomData()
                val types = resp.data ?: emptyList()
                _ui.value = _ui.value.copy(roomTypes = types)
                types.firstOrNull()?.let { selectType(it.roomTypeId ?: "") }
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = AuthRepository.friendly(e))
            }
        }
    }

    /** For item-shift: load the source order so the waiter can tick which sent lines to move. */
    fun loadSourceLines() {
        viewModelScope.launch {
            try {
                val snap = orders.updateOrder(fromTableId)
                val lines = snap?.orderDetailsList
                    ?.filter { it.orderDetailsId != null }
                    ?.map { d ->
                        OrderRepository.DraftLine(
                            itemId = d.itemId ?: "",
                            title = d.itemName ?: "",
                            quantity = (d.quantity as? Number)?.toInt() ?: d.quantity?.toString()?.toIntOrNull() ?: 1,
                            existingOrderDetailsId = d.orderDetailsId,
                            note = d.note ?: "",
                            isCombo = d.isCombo == true,
                            seatNo = d.seatNo?.toString()?.trim('"') ?: "1",
                            extras = d.orderExtraItem ?: emptyList(),
                        )
                    }
                    ?: emptyList()
                snap?.orderMasterId?.let { fromOrderMasterId = it.toString() }
                _ui.value = _ui.value.copy(sourceLines = lines)
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = AuthRepository.friendly(e))
            }
        }
    }

    fun selectType(typeId: String) {
        viewModelScope.launch {
            try {
                val resp = tables.roomsForType(typeId)
                val rooms = resp.data?.map {
                    com.danfe.restroorder.waiter.data.model.RoomEntry(
                        roomId = it.roomId, roomName = it.roomName, tableList = null
                    )
                } ?: emptyList()
                _ui.value = _ui.value.copy(selectedTypeId = typeId, rooms = rooms)
                rooms.firstOrNull()?.let { selectRoom(it.roomId ?: "") }
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = AuthRepository.friendly(e))
            }
        }
    }

    fun selectRoom(roomId: String) {
        viewModelScope.launch {
            try {
                val list = tables.tablesForRoom(roomId).filter { it.tableId != fromTableId }
                _ui.value = _ui.value.copy(selectedRoomId = roomId, targets = list)
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = AuthRepository.friendly(e))
            }
        }
    }

    fun toggleLine(itemId: String) {
        val sel = _ui.value.selectedKeys.toMutableSet()
        if (!sel.add(itemId)) sel.remove(itemId)
        _ui.value = _ui.value.copy(selectedKeys = sel)
    }

    /**
     * Shift whole table — old TableSelectionActivity flow:
     * checkOrder(OrderMasterId, SeatNo, TableId=target), then PIN, then
     * TableTransfer{fromOrderMasterId,fromSplitNo,toTable,toSplitNo,shiftedBy}.
     */
    fun shiftTable(target: TableRow, pin: String) {
        viewModelScope.launch {
            _ui.value = _ui.value.copy(busy = true, error = null)
            try {
                val okToMove = checkPinOrFinish(pin) ?: return@launch
                val (ok, msg) = tables.checkOrder(fromOrderMasterId, "1", target.tableId ?: "")
                if (!ok) {
                    _ui.value = _ui.value.copy(busy = false, error = msg ?: "Target table has a running order")
                    return@launch
                }
                val resp = tables.tableTransfer(
                    fromOrderMasterId, fromSplitNo, target.tableId ?: "", "0", okToMove,
                )
                finish(resp.statusCode?.toString()?.trim('"') == "200", resp.message)
            } catch (e: Exception) { fail(e) }
        }
    }

    /**
     * Shift selected items — old ItemShiftActivity flow (PIN first, then /Services body):
     * {fromTable,fromSplitNo,toTable,toSplitNo,shiftedBy,itemList[{ItemId,Quantity,IsCombo}]}
     */
    fun shiftItems(target: TableRow, pin: String) {
        viewModelScope.launch {
            _ui.value = _ui.value.copy(busy = true, error = null)
            try {
                val shiftedBy = checkPinOrFinish(pin) ?: return@launch
                val chosen = _ui.value.sourceLines.filter {
                    it.existingOrderDetailsId != null && it.itemId in _ui.value.selectedKeys
                }
                if (chosen.isEmpty()) {
                    _ui.value = _ui.value.copy(busy = false, error = "Select at least one item to shift")
                    return@launch
                }
                val resp = orders.shiftItems(
                    fromTable = fromTableId,
                    fromSplitNo = fromSplitNo,
                    toTable = target.tableId ?: "",
                    toSplitNo = "0",
                    shiftedBy = shiftedBy,
                    itemList = chosen.map {
                        mapOf("ItemId" to it.itemId, "Quantity" to it.quantity, "IsCombo" to it.isCombo)
                    },
                )
                finish(resp.statusCode?.toString()?.trim('"') == "200", resp.message)
            } catch (e: Exception) { fail(e) }
        }
    }

    /** CheckPin like the old app; returns the PIN user name, or null after surfacing an error. */
    private suspend fun checkPinOrFinish(pin: String): String? {
        val resp = auth.checkPin(pin)
        val user = resp.data?.userName
        if (user.isNullOrBlank()) {
            _ui.value = _ui.value.copy(busy = false, error = resp.message ?: "Wrong PIN")
            return null
        }
        return user
    }

    private fun finish(ok: Boolean, message: String?) {
        _ui.value = _ui.value.copy(
            busy = false,
            done = ok,
            info = if (ok) message?.trim('"') ?: "Done" else null,
            error = if (ok) null else message?.trim('"') ?: "Server refused the operation",
        )
    }

    private fun fail(e: Exception) {
        _ui.value = _ui.value.copy(busy = false, error = AuthRepository.friendly(e))
    }

    fun consumeError() { _ui.value = _ui.value.copy(error = null) }
}
