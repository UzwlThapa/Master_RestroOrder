package com.danfe.restroorder.waiter.data.api

import com.danfe.restroorder.waiter.data.model.*
import okhttp3.RequestBody
import retrofit2.http.*

/**
 * Every endpoint, method, body shape and content type matches the old app exactly
 * (see Step-1 analysis). Retrofit @Url is used because the base address changes per profile;
 * the old app likewise rebuilt its adapter on every call, so address changes apply immediately.
 */
interface RestroApi {

    // ---------- ROUSER/ROLoginWebService.asmx ----------
    // Old app posted form field json=<{username,password,WaiterIP}>
    @FormUrlEncoded
    @POST
    suspend fun checkLogin(@Url url: String, @Field("json") json: String): CheckLoginResponse

    @FormUrlEncoded
    @POST
    suspend fun loginPin(@Url url: String, @Field("json") json: String): LoginPinResponse

    @FormUrlEncoded
    @POST
    suspend fun loggedOut(@Url url: String, @Field("json") json: String): String

    @GET
    suspend fun getWaiterList(@Url url: String): List<WaiterInfo>

    // ---------- ropurchaseorder/ropurchaseorderwebservice.asmx ----------
    /** form field pin (NOT json) — preserved from CheckPinCode.java */
    @FormUrlEncoded
    @POST
    suspend fun checkPin(@Url url: String, @Field("pin") pin: String): CheckPinResponse

    @FormUrlEncoded
    @POST
    suspend fun checkOrder(@Url url: String, @Field("json") json: String): retrofit2.Response<String>

    @FormUrlEncoded
    @POST
    suspend fun updateOrder(@Url url: String, @Field("json") json: String): UpdateOrderResponse?

    @FormUrlEncoded
    @POST
    suspend fun purchaseOrder(@Url url: String, @Field("json") json: String): PurchaseOrderResponse

    @FormUrlEncoded
    @POST
    suspend fun cancelOrder(@Url url: String, @Field("json") json: String): CancelOrderResponse

    @FormUrlEncoded
    @POST
    suspend fun saveCanceledItems(@Url url: String, @Field("json") json: String): retrofit2.Response<String>

    @FormUrlEncoded
    @POST
    suspend fun tableTransfer(@Url url: String, @Field("json") json: String): TableTransferResponse

    /** form field tableId — preserved from APIforPay usage */
    @FormUrlEncoded
    @POST
    suspend fun apiForPay(@Url url: String, @Field("tableId") tableId: String): ApiForPayResponse

    @FormUrlEncoded
    @POST
    suspend fun tableOrderByRoom(@Url url: String, @Field("json") json: String): List<TableRow>

    @FormUrlEncoded
    @POST
    suspend fun roomOrderByRoomType(@Url url: String, @Field("json") json: String): RoomByTypeResponse

    /** No body, header Content-Type: application/json — preserved exactly */
    @Headers("Content-Type: application/json")
    @POST
    suspend fun getActiveBillTerm(@Url url: String, @Body body: RequestBody): BillTermResponse

    @FormUrlEncoded
    @POST
    suspend fun storeMergeTable(@Url url: String, @Field("json") json: String): StoreMergeTableResponse

    // ---------- RestroWebservices/RestroWebService.asmx ----------
    @GET
    suspend fun fullRestroRoomData(@Url url: String): FullRoomDataResponse

    // ---------- RORestroTable/ROTableWebService.asmx ----------
    /** form field tableId; response not parsed by the old app */
    @FormUrlEncoded
    @POST
    suspend fun unMergeTable(@Url url: String, @Field("tableId") tableId: String): String

    // ---------- ROI_Item/RoiItem.asmx ----------
    @GET
    suspend fun getAllUnitforItem(@Url url: String): MenuResponse

    @FormUrlEncoded
    @POST
    suspend fun updateItemStockStatus(@Url url: String, @Field("json") json: String): StockStatusResponse

    // ---------- Services/RestroWebService.asmx/shiftItems (base /Services, kept identical — answer #11) ----------
    @FormUrlEncoded
    @POST
    suspend fun shiftItems(@Url url: String, @Field("json") json: String): ShiftItemsResponse

    /** Test-connection probe: HEAD/GET on the login service page. Any HTTP response = server reachable. */
    @GET
    suspend fun probe(@Url url: String): retrofit2.Response<Any>
}
