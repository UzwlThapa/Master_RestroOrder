package com.danfe.restroorder.waiter.data.repository

import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.api.ApiFactory
import com.danfe.restroorder.waiter.data.local.ServerProfile
import com.danfe.restroorder.waiter.data.model.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONArray
import org.json.JSONObject

/**
 * Login / session endpoints. Bodies are built with org.json exactly like the old app so key
 * order and types stay identical (Retrofit 1 serialized a JsonObject into the json= field).
 */
class AuthRepository(private val app: App, private val session: Session) {

    /** POST .../CheckLogin  json={username,password,WaiterIP} */
    suspend fun checkLogin(profile: ServerProfile, username: String, password: String): CheckLoginResponse {
        val body = JSONObject()
            .put("username", username)
            .put("password", password)
            .put("WaiterIP", session.waiterIp(app))
        return ApiFactory.apiFor(profile)
            .checkLogin("${ApiFactory.modulesBase(profile)}/ROUSER/ROLoginWebService.asmx/CheckLogin", body.toString())
    }

    /** POST .../LoginPin  json={pin,WaiterIP} */
    suspend fun loginPin(profile: ServerProfile, pin: String): LoginPinResponse {
        val body = JSONObject()
            .put("pin", pin)
            .put("WaiterIP", session.waiterIp(app))
        return ApiFactory.apiFor(profile)
            .loginPin("${ApiFactory.modulesBase(profile)}/ROUSER/ROLoginWebService.asmx/LoginPin", body.toString())
    }

    /** GET .../getWaiterList — used for waiter list/forwarding data as in the old app. */
    suspend fun waiterList(): List<WaiterInfo> =
        session.api().getWaiterList(session.modulesUrl("ROUSER/ROLoginWebService.asmx/getWaiterList"))

    /**
     * POST .../CheckPin  form field pin (NOT json — preserved from CheckPinCode.java).
     * Returns UserName + Roles; that username is what goes into later request bodies.
     */
    suspend fun checkPin(pin: String): CheckPinResponse =
        session.api().checkPin(
            session.modulesUrl("ROPurchaseOrder/ROPurchaseOrderWebService.asmx/CheckPin"), pin
        )

    /** Test connection (settings screen): any HTTP response from the login service page counts as pass. */
    sealed class TestResult {
        data object Pass : TestResult()
        data class Fail(val reason: String) : TestResult()
    }

    suspend fun testConnection(profile: ServerProfile): TestResult = try {
        val url = "${ApiFactory.modulesBase(profile)}/ROUSER/ROLoginWebService.asmx"
        val resp = ApiFactory.apiFor(profile).probe(url)
        if (resp.code() > 0) TestResult.Pass else TestResult.Fail("No response from server")
    } catch (e: Exception) {
        TestResult.Fail(friendly(e))
    }

    companion object {
        fun friendly(e: Throwable): String = when {
            e is java.net.SocketTimeoutException -> "Server did not respond within 20 s. Check the IP/port and that this PC is on."
            e is java.net.ConnectException -> "Cannot connect. Is WiFi on and the address correct?"
            e is java.net.UnknownHostException -> "Host name not found. Try the IP address instead."
            e is javax.net.ssl.SSLException -> "HTTPS handshake failed. If the server uses a self-signed certificate, enable \"Trust certificate\" for this profile."
            else -> e.message ?: "Unknown error: ${e.javaClass.simpleName}"
        }
    }

    /** getActiveBillTerm: no body but Content-Type application/json (kept exactly). */
    suspend fun activeBillTerm(): BillTermResponse =
        session.api().getActiveBillTerm(
            session.modulesUrl("ropurchaseorder/ropurchaseorderwebservice.asmx/getActiveBillTerm"),
            ByteArray(0).toRequestBody("application/json".toMediaTypeOrNullSafe()),
        )

    private fun String.toMediaTypeOrNullSafe(): okhttp3.MediaType? = this.toMediaType()
}

/** Small JSON-array helper to keep body building readable in repositories. */
fun jsonArray(vararg objs: Any?): JSONArray = JSONArray().apply { objs.forEach { put(it) } }
