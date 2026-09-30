package com.danfe.restroorder.waiter.util

import android.content.Context
import android.net.wifi.WifiManager
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Old app sent its own WiFi IPv4 + ":8000" as WaiterIP at login (LoginActivity.java / Util.getIpAccess).
 * Answer #10: keep sending exactly that, even though the new app does not run a server on port 8000.
 */
fun waiterIp(ctx: Context): String {
    val wifi = ctx.applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
    @Suppress("DEPRECATION")
    val ip = wifi?.connectionInfo?.ipAddress ?: 0
    return if (ip != 0) intToIp(ip) + ":8000" else ""
}

@Suppress("MagicNumber")
private fun intToIp(ip: Int): String =
    "${ip and 0xFF}.${(ip shr 8) and 0xFF}.${(ip shr 16) and 0xFF}.${(ip shr 24) and 0xFF}"

private val timeFmt = SimpleDateFormat("HH:mm:ss.SSS", Locale.US)
fun now(): String = timeFmt.format(Date())
