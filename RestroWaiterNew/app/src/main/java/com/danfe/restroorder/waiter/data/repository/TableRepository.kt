package com.danfe.restroorder.waiter.data.repository

import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.*
import org.json.JSONArray
import org.json.JSONObject

/**
 * Tables & rooms. Endpoints and bodies identical to the old app:
 *  - GET  FullRestroRoomData                 (room types -> rooms -> tables tree)
 *  - POST TableOrderByRoom   json={restroRoomId}
 *  - POST RoomOrderByRoomType json={RoomTypeID}
 *  - POST StoreMergeTable    json={MergeTableInfo:[{TableID,MergeID,MergeTableList}]}
 *  - form unMergeTable       field tableId (RORestroTable service; response not parsed before, still ignored)
 */
class TableRepository(private val app: App, private val session: Session) {

    suspend fun fullRoomData(): FullRoomDataResponse =
        session.api().fullRestroRoomData(
            session.modulesUrl("RestroWebservices/RestroWebService.asmx/FullRestroRoomData")
        )

    suspend fun tablesForRoom(roomId: String): List<TableRow> {
        val body = JSONObject().put("restroRoomId", roomId)
        return session.api().tableOrderByRoom(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/TableOrderByRoom"),
            body.toString(),
        )
    }

    suspend fun roomsForType(roomTypeId: String): RoomByTypeResponse {
        val body = JSONObject().put("RoomTypeID", roomTypeId)
        return session.api().roomOrderByRoomType(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/RoomOrderByRoomType"),
            body.toString(),
        )
    }

    /** Merge tables — same shape as the old StoreMergeTable call. */
    suspend fun storeMerge(entries: List<Pair<String, Pair<String, String>>>) {
        // entries: Triple(tableId, mergeId, mergeTableList)
        val arr = JSONArray()
        entries.forEach { (tableId, pair) ->
            arr.put(JSONObject()
                .put("TableID", tableId)
                .put("MergeID", pair.first)
                .put("MergeTableList", pair.second))
        }
        val body = JSONObject().put("MergeTableInfo", arr)
        session.api().storeMergeTable(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/StoreMergeTable"),
            body.toString(),
        )
    }

    suspend fun unmergeTable(tableId: String): String =
        session.api().unMergeTable(
            session.modulesUrl("RORestroTable/ROTableWebService.asmx/UnMergeTable"), tableId
        )

    /** Shift a whole order/table — TableTransfer, identical body to the old TableSelectionActivity flow. */
    suspend fun tableTransfer(fromOrderMasterId: String, fromSplitNo: String, toTable: String, toSplitNo: String, shiftedBy: String): TableTransferResponse {
        val body = JSONObject()
            .put("fromOrderMasterId", fromOrderMasterId)
            .put("fromSplitNo", fromSplitNo)
            .put("toTable", toTable)
            .put("toSplitNo", toSplitNo)
            .put("shiftedBy", shiftedBy)
        return session.api().tableTransfer(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/TableTransfer"),
            body.toString(),
        )
    }

    /** checkOrder before shifting: HTTP 200 means OK; data[] carries ErrorNumber/ErrorMessage. */
    suspend fun checkOrder(orderMasterId: String, seatNo: String, tableId: String): Pair<Boolean, String?> {
        val body = JSONObject()
            .put("OrderMasterId", orderMasterId)
            .put("SeatNo", seatNo)
            .put("TableId", tableId)
        val resp = session.api().checkOrder(
            // lowercase path exactly as in the old code (ropurchaseorder/...checkOrder)
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/checkOrder"),
            body.toString(),
        )
        if (!resp.isSuccessful) return false to "Server refused (HTTP ${resp.code()})"
        val text = resp.body() ?: ""
        return try {
            val obj = JSONObject(text)
            val data = obj.optJSONArray("data")
            if (data != null && data.length() > 0) {
                val err = data.getJSONObject(0).optString("ErrorMessage")
                false to err.ifBlank { "Order check failed" }
            } else true to null
        } catch (_: Exception) {
            true to null // 200 with unparsable/empty body behaved as OK in the old app
        }
    }
}
