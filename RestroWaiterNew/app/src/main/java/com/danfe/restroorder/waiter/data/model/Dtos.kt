package com.danfe.restroorder.waiter.data.model

import com.google.gson.annotations.SerializedName

/**
 * DTOs mirror the decompiled app's Gson models exactly. Field names are the JSON keys the
 * server sends/expects — never rename them (case included). Nullability follows what the old
 * code actually read; where the old code would NPE we keep a nullable type and surface a friendly error.
 */

// ---------- ROUSER/ROLoginWebService.asmx ----------

/** POST /Modules/ROUSER/ROLoginWebService.asmx/CheckLogin  body {username,password,WaiterIP} */
data class CheckLoginResponse(
    @SerializedName("Status") val status: String?,        // "Success" | "LoggedIn" | other
    @SerializedName("Username") val username: String?,
    @SerializedName("RoleNames") val roleNames: String?,
    @SerializedName("UserID") val userId: String?,
    @SerializedName("Password") val password: String?,    // server echoes it back; kept as-is
)

/** POST .../LoginPin  body {pin,WaiterIP} */
data class LoginPinResponse(
    @SerializedName("statusCode") val statusCode: Any?,   // UNKNOWN: int vs string in decompile
    @SerializedName("message") val message: String?,
    @SerializedName("data") val data: LoginPinData?,
)

data class LoginPinData(
    @SerializedName("UserName") val userName: String?,
    @SerializedName("UserID") val userId: String?,
    @SerializedName("Roles") val roles: String?,
    @SerializedName("DisablePin") val disablePin: Boolean?,
    @SerializedName("Message") val message: String?,
    @SerializedName("OrderMenuImageshow") val orderMenuImageShow: String?,
    @SerializedName("OrderMenuListType") val orderMenuListType: String?,
)

/** POST .../LoggedOut  body {username} — response ignored by the old app. */

/** GET /Modules/ROUSER/ROLoginWebService.asmx/getWaiterList */
data class WaiterInfo(
    @SerializedName("WaiterName") val waiterName: String?,
    @SerializedName("WaiterIP") val waiterIp: String?,
    @SerializedName("Department") val department: String?,
    @SerializedName("ItemName") val itemName: String?,
    @SerializedName("OrderDetailId") val orderDetailId: String?,
    @SerializedName("RoomName") val roomName: String?,
    @SerializedName("TableName") val tableName: String?,
)

// ---------- ropurchaseorder/ropurchaseorderwebservice.asmx ----------

/** POST .../CheckPin  form field pin */
data class CheckPinResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("message") val message: String?,
    @SerializedName("data") val data: CheckPinData?,
)

data class CheckPinData(
    @SerializedName("UserName") val userName: String?,
    @SerializedName("Roles") val roles: String?,
)

/** POST .../checkOrder  body {OrderMasterId,SeatNo,TableId}; HTTP 200 means OK */
data class CheckOrderResponse(
    @SerializedName("data") val data: List<CheckOrderError>?,
)

data class CheckOrderError(
    @SerializedName("ErrorNumber") val errorNumber: String?,
    @SerializedName("ErrorMessage") val errorMessage: String?,
)

/**
 * POST .../UpdateOrder  body {TableId[,RoomId]}
 * Returns a bare object (or null for an empty table). This is the current-order snapshot of a table.
 */
data class UpdateOrderResponse(
    @SerializedName("OrderMasterID") val orderMasterId: String?,
    @SerializedName("UserName") val userName: String?,
    @SerializedName("IsSplit") val isSplit: Boolean?,
    @SerializedName("GuestNo") val guestNo: Any?,
    @SerializedName("RoomTotal") val roomTotal: Any?,
    @SerializedName("AdvancePaid") val advancePaid: Any?,
    @SerializedName("RoomBookedDays") val roomBookedDays: Any?,
    @SerializedName("OrderDetailsList") val orderDetailsList: List<OrderDetail>?,
)

data class OrderDetail(
    @SerializedName("OrderDetailsID") val orderDetailsId: String?,
    @SerializedName("ROI_ItemId") val itemId: String?,
    @SerializedName("ROI_ItemName") val itemName: String?,
    @SerializedName("Quantity") val quantity: Any?,
    @SerializedName("Rate") val rate: Any?,
    @SerializedName("Status") val status: String?,           // Ordered / InProgress / Complete tabs
    @SerializedName("SeatNo") val seatNo: Any?,
    @SerializedName("Note") val note: String?,
    @SerializedName("ExtraCharge") val extraCharge: Any?,
    @SerializedName("IsCombo") val isCombo: Boolean?,
    @SerializedName("CostCenterId") val costCenterId: String?,
    @SerializedName("orderExtraItem") val orderExtraItem: List<OrderExtraItem>?,
)

data class OrderExtraItem(
    @SerializedName("ItemID") val itemId: String?,
    @SerializedName("ExtraItemID") val extraItemId: String?,
    @SerializedName("ExtraItem") val extraItem: String?,
    @SerializedName("ExtraPrice") val extraPrice: Any?,
    @SerializedName("Quantity") val quantity: Any?,
    @SerializedName("SeatNo") val seatNo: Any?,
)

/** POST .../PurchaseOrder — send order/KOT. Success == statusCode 200; message may be "\"Printing Failed\"". */
data class PurchaseOrderResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("message") val message: String?,
)

/** POST .../CancelOrderIntoDataBase */
data class CancelOrderResponse(
    @SerializedName("message") val message: String?,         // "Print Failed." handling preserved
)

/** POST .../SaveCanceledItems — old app judged success by HTTP reason phrase "OK", not the body. */
data class SaveCanceledItemsResponse(
    @SerializedName("success") val success: Any?,
)

/** POST .../TableTransfer */
data class TableTransferResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("message") val message: String?,
)

/** POST .../APIforPay  form field tableId — Status == "Success" */
data class ApiForPayResponse(
    @SerializedName("Status") val status: String?,
)

/** POST .../TableOrderByRoom  body {restroRoomId} — bare array */
data class TableRow(
    @SerializedName("restrotableId") val tableId: String?,
    @SerializedName("restrotableTitle") val tableTitle: String?,
    @SerializedName("restrotablesStatusID") val statusId: Any?,   // 7 = occupied w/ running order (inferred), 6 = valid shift target
    @SerializedName("Seatcap") val seatCap: Any?,
    @SerializedName("MergeID") val mergeId: String?,
    @SerializedName("MergeTableList") val mergeTableList: String?,
    @SerializedName("BillPaid") val billPaid: Any?,
    @SerializedName("IsTable") val isTable: Any?,
    @SerializedName("OrderMasterId") val orderMasterId: String?,
    @SerializedName("GuestNo") val guestNo: Any?,
    @SerializedName("Rate") val rate: Any?,
    @SerializedName("tableDate") val tableDate: String?,
    @SerializedName("tabletime") val tableTime: String?,
    @SerializedName("IsCancelled") val isCancelled: Any?,
)

/** POST .../RoomOrderByRoomType  body {RoomTypeID} */
data class RoomByTypeResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("Data") val data: List<RoomRow>?,
    @SerializedName("message") val message: String?,
)

data class RoomRow(
    @SerializedName("restroRoomId") val roomId: String?,
    @SerializedName("restroRoom") val roomName: String?,
    @SerializedName("RoomStatusId") val roomStatusId: Any?,
)

/** POST .../getActiveBillTerm  (Content-Type: application/json, no body) */
data class BillTermResponse(
    @SerializedName("d") val d: BillTermD?,
)

data class BillTermD(
    @SerializedName("billingTerm") val billingTerm: List<Any?>?,
    @SerializedName("costCenter") val costCenter: List<CostCenter>?,
)

data class CostCenter(
    @SerializedName("CostCenterID") val id: String?,
    @SerializedName("CostCenterName") val name: String?,
    @SerializedName("coDiscount") val discount: Any?,
)

/** POST .../StoreMergeTable */
data class StoreMergeTableResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("message") val message: String? = null,
)

/** POST .../UnMergeTable — legacy returns void/null; parse leniently so odd bodies never crash. */
data class UnMergeTableResponse(
    @SerializedName("statusCode") val statusCode: Any? = null,
    @SerializedName("message") val message: String? = null,
)

// ---------- RestroWebservices/RestroWebService.asmx (under /Modules) ----------

/** GET FullRestroRoomData — statusCode 200 OK / 100 error */
data class FullRoomDataResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("data") val data: List<RoomTypeGroup>?,
)

data class RoomTypeGroup(
    @SerializedName("RoomTypeID") val roomTypeId: String?,
    @SerializedName("Title") val title: String?,
    @SerializedName("roomlist") val roomList: List<RoomEntry>?,
)

data class RoomEntry(
    @SerializedName("RoomID") val roomId: String?,          // UNKNOWN exact key casing beyond RoomTypeID/Title/roomlist
    @SerializedName("RoomName") val roomName: String?,
    @SerializedName("tableList") val tableList: List<TableRow>?,
)

/** GET KitchenOrderApi / POST KitchenOrderApiForEvents — kitchen display (dropped from v1; types kept for reference) */
data class KitchenOrderResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("data") val data: List<KitchenCostCenter>?,
)

data class KitchenCostCenter(
    @SerializedName("CostCenterName") val costCenterName: String?,
    @SerializedName("tableList") val tableList: List<Any?>?,
)

// ---------- ROI_Item/RoiItem.asmx ----------

/** GET GetAllUnitforItem — full menu tree */
data class MenuResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("data") val data: List<MenuGroup>?,
)

data class MenuGroup(
    @SerializedName("Itemgroup") val itemgroup: List<MenuItem>?,
)

data class MenuItem(
    @SerializedName("ItemId") val itemId: String?,
    @SerializedName("ItemName") val itemName: String?,
    @SerializedName("ItemCode") val itemCode: String?,
    @SerializedName("SRate") val sRate: Any?,
    @SerializedName("Level") val level: Any?,
    @SerializedName("PItemId") val pItemId: String?,
    @SerializedName("IsCategory") val isCategory: Boolean?,
    @SerializedName("IsCombo") val isCombo: Boolean?,
    @SerializedName("IsOutOfStock") val isOutOfStock: Boolean?,
    @SerializedName("CostCenterID") val costCenterId: String?,
    @SerializedName("CostCenterName") val costCenterName: String?,
    @SerializedName("Currency") val currency: String?,      // shown as-is (answer #19)
    @SerializedName("ImagePath") val imagePath: String?,
    @SerializedName("Details") val details: String?,
    @SerializedName("extradata") val extradata: List<ExtraMenu>?,
)

data class ExtraMenu(
    @SerializedName("ExtraItemID") val extraItemId: String?,
    @SerializedName("ExtraItem") val extraItem: String?,
    @SerializedName("ExtraPrice") val extraPrice: Any?,
)

/** POST UpdateItemStockStatus  body {ItemId} only — server toggles (behaviour UNKNOWN, request identical) */
data class StockStatusResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("message") val message: String?,
)

// ---------- Services/RestroWebService.asmx/shiftItems ----------

data class ShiftItemsResponse(
    @SerializedName("statusCode") val statusCode: Any?,
    @SerializedName("message") val message: String?,
)
