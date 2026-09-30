package com.danfe.restroorder.waiter

import com.danfe.restroorder.waiter.data.model.CheckLoginResponse
import com.danfe.restroorder.waiter.data.model.LoginPinResponse
import com.danfe.restroorder.waiter.data.model.UpdateOrderResponse
import com.google.gson.Gson
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Gson must read exactly the server key names seen in the decompile. */
class DtosParseTest {
    private val gson = Gson()

    @Test fun checkLoginKeys() {
        val r = gson.fromJson(
            """{"Status":"Success","Username":"waiter1","RoleNames":"Waiter","UserID":"5","Password":"p"}""",
            CheckLoginResponse::class.java,
        )
        assertEquals("Success", r.status)
        assertEquals("waiter1", r.username)
        assertEquals("5", r.userId)
    }

    @Test fun loginPinDataKeys() {
        val r = gson.fromJson(
            """{"statusCode":200,"message":"ok","data":{"UserName":"w1","UserID":"5","Roles":"Waiter","DisablePin":true,"Message":"","OrderMenuImageshow":"1","OrderMenuListType":"Grid"}}""",
            LoginPinResponse::class.java,
        )
        assertEquals("w1", r.data?.userName)
        assertEquals(true, r.data?.disablePin)
    }

    @Test fun updateOrderIsNullableAndUntypedNumbersStayAny() {
        val r = gson.fromJson(
            """{"OrderMasterID":"42","UserName":"w1","IsSplit":false,"GuestNo":2,"RoomTotal":null,"OrderDetailsList":[{"OrderDetailsID":"7","ROI_ItemId":"3","ROI_ItemName":"Momo","Quantity":2,"Rate":"120.00","Status":"Ordered","SeatNo":1,"Note":"","ExtraCharge":0,"IsCombo":false,"CostCenterId":"1","orderExtraItem":[]}]}""",
            UpdateOrderResponse::class.java,
        )
        assertEquals("42", r.orderMasterId)
        assertEquals(1, r.orderDetailsList?.size)
        val d = r.orderDetailsList!!.first()
        assertEquals("Momo", d.itemName)
        assertTrue(d.orderDetailsId == "7")
    }
}
