package com.danfe.restroorder.waiter.data.repository

import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.api.ApiFactory
import com.danfe.restroorder.waiter.data.model.*
import org.json.JSONArray
import org.json.JSONObject

/**
 * Ordering endpoints. Request bodies are assembled with org.json to keep the old app's exact
 * key names and structure (PurchaseOrder / UpdateOrder / CancelOrderIntoDataBase / SaveCanceledItems /
 * APIforPay / UpdateItemStockStatus / shiftItems). No totals are ever sent — like the old app,
 * discounts/totals are computed on-device for display only.
 */
class OrderRepository(private val app: App, private val session: Session) {

    /** GET menu (cached in memory; the old app cached it in greenDAO). */
    @Volatile private var menuCache: List<MenuItem>? = null

    suspend fun loadMenu(forceRefresh: Boolean = false): List<MenuItem> {
        if (!forceRefresh) menuCache?.let { return it }
        val resp = session.api().getAllUnitforItem(
            session.modulesUrl("ROI_Item/RoiItem.asmx/GetAllUnitforItem")
        )
        val items = resp.data?.flatMap { it.itemgroup ?: emptyList() } ?: emptyList()
        if (items.isNotEmpty()) menuCache = items
        return items
    }

    fun imageUrl(path: String): String = ApiFactory.imageUrl(session.requireProfile(), path)

    /** POST UpdateOrder  json={TableId[,RoomId]} — current order snapshot; may be null for an empty table. */
    suspend fun updateOrder(tableId: String, roomId: String? = null): UpdateOrderResponse? {
        val body = JSONObject().put("TableId", tableId)
        if (roomId != null) body.put("RoomId", roomId)
        return session.api().updateOrder(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/UpdateOrder"),
            body.toString(),
        )
    }

    data class DraftLine(
        val itemId: String,
        val title: String,
        var quantity: Int,
        val existingOrderDetailsId: String?,   // null => new line
        var note: String,
        val isCombo: Boolean,
        var seatNo: String,
        val extras: List<OrderExtraItem>,
        val homePackQty: Int = 0,
    )

    /**
     * POST PurchaseOrder. Body mirrors MainActivity.sendOrder exactly:
     * OrderStatus 0 for a new order / 1 for an existing one; SeatNo included only when not split;
     * UserName is the user returned by CheckPin (not the login user) — preserved from the old app.
     */
    suspend fun sendOrder(
        orderMasterId: String,
        tableId: String,
        roomId: String?,
        isSplit: Boolean,
        guestNo: String,
        seatNo: String,
        pinUserName: String,
        lines: List<DraftLine>,
    ): PurchaseOrderResponse {
        val isNew = orderMasterId.isBlank() || orderMasterId == "0"
        val details = JSONArray()
        val extraArr = JSONArray()
        lines.forEach { l ->
            val o = JSONObject()
                .put("title", l.title)
                .put("Quantity", l.quantity)
                .put("ItemId", l.itemId)
                .put("OrderDetailsID", l.existingOrderDetailsId ?: "")
                .put("isCancelled", false)
                .put("Note", l.note)
                .put("ExtraCharge", extrasTotal(l))
                .put("HomePackQty", l.homePackQty)
                .put("Status", if (l.existingOrderDetailsId == null) "" else "Ordered")
                .put("IsCombo", l.isCombo)
                .put("SeatNo", l.seatNo)
            details.put(o)
            l.extras.forEach { e ->
                extraArr.put(JSONObject()
                    .put("ItemID", e.itemId)
                    .put("ExtraItemID", e.extraItemId)
                    .put("ExtraItem", e.extraItem)
                    .put("ExtraPrice", e.extraPrice)
                    .put("Quantity", e.quantity)
                    .put("SeatNo", e.seatNo))
            }
        }

        val body = JSONObject()
            .put("OrderStatus", if (isNew) 0 else 1)
            .put("OrderMasterId", if (isNew) "" else orderMasterId)
            .put("TableId", tableId)
        if (roomId != null) body.put("RoomId", roomId)
        body.put("Remarks", " ")
            .put("IsSplit", isSplit)
            .put("GuestNo", guestNo)
        if (!isSplit) body.put("SeatNo", seatNo)
        body.put("IsCancelled", false)
            .put("UserName", pinUserName)
            .put("OrderTypeID", 1)
            .put("orderDetailsList", details)
            .put("orderExtraItem", extraArr)

        return session.api().purchaseOrder(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/PurchaseOrder"),
            body.toString(),
        )
    }

    private fun extrasTotal(l: DraftLine): Double =
        l.extras.sumOf { (it.extraPrice as? Double ?: it.extraPrice?.toString()?.toDoubleOrNull() ?: 0.0) *
            (it.quantity as? Double ?: it.quantity?.toString()?.toDoubleOrNull() ?: 1.0) }

    /** POST CancelOrderIntoDataBase — CancelBy requires role "Void Bill" (checked client-side too). */
    suspend fun cancelOrder(
        orderMasterId: String, tableId: String, reason: String,
        guestNo: String, seatNo: String, cancelBy: String, pinUserName: String,
    ): CancelOrderResponse {
        val body = JSONObject()
            .put("OrderMasterID", orderMasterId)
            .put("TableId", tableId)
            .put("IsCancelled", true)
            .put("CancelReason", reason)
            .put("GuestNo", guestNo)
            .put("SeatNo", seatNo)
            .put("CancelBy", cancelBy)
            .put("UserName", pinUserName)
        return session.api().cancelOrder(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/CancelOrderIntoDataBase"),
            body.toString(),
        )
    }

    /** POST SaveCanceledItems — success judged by HTTP reason phrase "OK", like the old app. */
    suspend fun saveCanceledItems(items: List<Map<String, Any?>>): Boolean {
        val arr = JSONArray()
        items.forEach { m -> arr.put(JSONObject(m)) }
        val body = JSONObject().put("cancelledOrderItems", arr)
        val resp = session.api().saveCanceledItems(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/SaveCanceledItems"),
            body.toString(),
        )
        return resp.message() == "OK" || resp.isSuccessful && resp.code() == 200
    }

    /** POST APIforPay — form field tableId; Status == "Success". */
    suspend fun pay(tableId: String): ApiForPayResponse =
        session.api().apiForPay(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/APIforPay"), tableId
        )

    /** POST UpdateItemStockStatus — body {ItemId} only; server toggles (behaviour UNKNOWN, request identical). */
    suspend fun toggleOutOfStock(itemId: String): StockStatusResponse {
        val body = JSONObject().put("ItemId", itemId)
        return session.api().updateItemStockStatus(
            session.modulesUrl("ROI_Item/RoiItem.asmx/UpdateItemStockStatus"), body.toString()
        )
    }

    /** POST /Services/RestroWebService.asmx/shiftItems — base kept identical (answer #11). */
    suspend fun shiftItems(
        fromTable: String, fromSplitNo: String, toTable: String, toSplitNo: String,
        shiftedBy: String, itemList: List<Map<String, Any?>>,
    ): ShiftItemsResponse {
        val arr = JSONArray()
        itemList.forEach { arr.put(JSONObject(it)) }
        val body = JSONObject()
            .put("fromTable", fromTable)
            .put("fromSplitNo", fromSplitNo)
            .put("toTable", toTable)
            .put("toSplitNo", toSplitNo)
            .put("shiftedBy", shiftedBy)
            .put("itemList", arr)
        return session.api().shiftItems(
            session.servicesUrl("RestroWebService.asmx/shiftItems"), body.toString()
        )
    }
}
