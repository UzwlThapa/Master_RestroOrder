package com.danfe.restroorder.waiter.ui.tables

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.RoomTypeGroup
import com.danfe.restroorder.waiter.data.model.TableRow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

/**
 * Room type -> room -> table grid, mirroring TableActivity. Merge mode + long-press actions
 * (shift table / shift items / show bill / unmerge) are handled here; PIN gating happens in the UI
 * via PinDialog before any of those calls (kept from the old app).
 */
class TablesViewModel(private val app: App) : ViewModel() {

    private val repo = com.danfe.restroorder.waiter.data.repository.TableRepository(app, app.session)

    data class Ui(
        val busy: Boolean = false,
        val error: String? = null,
        val roomTypes: List<RoomTypeGroup> = emptyList(),
        val selectedTypeId: String? = null,
        val rooms: List<com.danfe.restroorder.waiter.data.model.RoomEntry> = emptyList(),
        val selectedRoomId: String? = null,
        val tables: List<TableRow> = emptyList(),
        val mergeMode: Boolean = false,
        val mergeSelection: MutableList<String> = mutableListOf(),
        val billFilterActive: Boolean = false,
        val pendingBillOrderIds: Set<String> = emptySet(),
    )

    private val _ui = MutableStateFlow(Ui())
    val ui: StateFlow<Ui> = _ui

    init { refresh() }

    /**
     * restrotablesStatusID == 5 is the server's "pending bill" table status (per legacy app).
     * The set below mirrors that status from the already-loaded TableOrderByRoom rows so the UI
     * can label/filter pending-bill tables. No extra endpoint call — keeps the API contract intact.
     */
    private fun computePendingBillIds(tables: List<TableRow>): Set<String> =
        tables.mapNotNull { t ->
            val st = t.statusId?.toString()?.trim('"')
            if (st == "5") t.tableId?.toString()?.trim('"') else null
        }.toSet()

    fun toggleBillFilter() {
        _ui.value = _ui.value.copy(billFilterActive = !_ui.value.billFilterActive)
    }

    fun refresh() {
        _ui.value = _ui.value.copy(busy = true, error = null)
        viewModelScope.launch {
            try {
                val resp = repo.fullRoomData()
                val code = resp.statusCode?.toString()?.trim('"')
                if (code == "100") {
                    _ui.value = _ui.value.copy(busy = false, error = "Server returned an error loading rooms.")
                    return@launch
                }
                val types = resp.data ?: emptyList()
                _ui.value = _ui.value.copy(busy = false, roomTypes = types)
                types.firstOrNull()?.let { selectType(it.roomTypeId ?: "") }
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(busy = false, error = com.danfe.restroorder.waiter.data.repository.AuthRepository.friendly(e))
            }
        }
    }

    fun selectType(typeId: String) {
        viewModelScope.launch {
            try {
                val resp = repo.roomsForType(typeId)
                val rooms = resp.data?.map { r ->
                    com.danfe.restroorder.waiter.data.model.RoomEntry(
                        roomId = r.roomId, roomName = r.roomName, tableList = null
                    )
                } ?: emptyList()
                _ui.value = _ui.value.copy(selectedTypeId = typeId, rooms = rooms, selectedRoomId = null, tables = emptyList())
                rooms.firstOrNull()?.let { selectRoom(it.roomId ?: "") }
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = com.danfe.restroorder.waiter.data.repository.AuthRepository.friendly(e))
            }
        }
    }

    fun selectRoom(roomId: String) {
        viewModelScope.launch {
            try {
                val tables = repo.tablesForRoom(roomId)
                _ui.value = _ui.value.copy(
                    selectedRoomId = roomId,
                    tables = tables,
                    pendingBillOrderIds = computePendingBillIds(tables),
                )
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = com.danfe.restroorder.waiter.data.repository.AuthRepository.friendly(e))
            }
        }
    }

    fun toggleMergeMode() {
        _ui.value = _ui.value.copy(mergeMode = !_ui.value.mergeMode, mergeSelection = mutableListOf())
    }

    fun onTableTap(t: TableRow, openTable: (TableRow) -> Unit) {
        if (!_ui.value.mergeMode) { openTable(t); return }
        val sel = _ui.value.mergeSelection.toMutableList()
        val id = t.tableId ?: return
        if (id in sel) sel.remove(id) else sel.add(id)
        _ui.value = _ui.value.copy(mergeSelection = sel)
        if (sel.size >= 2) commitMerge(sel.toList())
    }

    /** StoreMergeTable with the same body shape as the old app. */
    private fun commitMerge(ids: List<String>) {
        viewModelScope.launch {
            try {
                val mergeId = ids.joinToString("-")
                val list = ids.joinToString(",")
                repo.storeMerge(ids.map { it to (mergeId to list) })
                _ui.value = _ui.value.copy(mergeMode = false, mergeSelection = mutableListOf())
                selectRoom(_ui.value.selectedRoomId ?: "")
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = com.danfe.restroorder.waiter.data.repository.AuthRepository.friendly(e))
            }
        }
    }

    fun unmerge(tableId: String) {
        viewModelScope.launch {
            try {
                repo.unmergeTable(tableId) // response not parsed by the old app either
                selectRoom(_ui.value.selectedRoomId ?: "")
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(error = com.danfe.restroorder.waiter.data.repository.AuthRepository.friendly(e))
            }
        }
    }

    fun consumeError() { _ui.value = _ui.value.copy(error = null) }
}
