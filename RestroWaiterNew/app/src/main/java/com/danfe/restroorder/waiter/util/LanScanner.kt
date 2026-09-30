package com.danfe.restroorder.waiter.util

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.net.Inet4Address
import java.net.NetworkInterface

/**
 * LAN auto-discovery (answer #14): enumerate the phone's /24 subnet from its own WiFi IPv4
 * and probe <scheme>://<ip>:<port><prefix>/ROUSER/ROLoginWebService.asmx on each host.
 * Runs with bounded parallelism; pure best-effort, never required for normal use.
 */
object LanScanner {
    data class Found(val address: String, val port: Int)

    suspend fun scan(
        ctx: Context,
        ports: List<Int>,
        https: Boolean,
        pathPrefix: String,
        onResult: (Found) -> Unit,
    ) {
        val localIp = localIpv4(ctx) ?: return
        val prefix = pathPrefix.ifBlank { "/Modules" }
        val subnet = localIp.substringBeforeLast('.')
        val probePath = "$prefix/ROUSER/ROLoginWebService.asmx"
        val hosts = (1..254).map { "$subnet.$it" }.toMutableList()
        hosts.shuffle()
        val chunk = 32
        for (part in hosts.chunked(chunk)) {
            kotlinx.coroutines.coroutineScope {
                for (host in part) launch(Dispatchers.IO) {
                    for (port in ports) {
                        val url = "${if (https) "https" else "http"}://$host:$port$probePath"
                        if (reachable(url)) { onResult(Found("$host:$port", port)); break }
                    }
                }
            }
        }
    }

    private fun reachable(url: String): Boolean = try {
        val conn = java.net.URL(url).openConnection() as java.net.HttpURLConnection
        conn.connectTimeout = 700
        conn.readTimeout = 700
        conn.requestMethod = "GET"
        conn.instanceFollowRedirects = false
        conn.responseCode // any HTTP response (even 4xx/500) proves a RestroOrder-ish IIS is there
        true
    } catch (_: Exception) {
        false
    }

    private fun localIpv4(ctx: Context): String? {
        // Prefer WifiManager (gives the DHCP address even before we read interfaces)
        @Suppress("DEPRECATION")
        val wifi = ctx.applicationContext.getSystemService(Context.WIFI_SERVICE)
            as? android.net.wifi.WifiManager
        val ip = wifi?.connectionInfo?.ipAddress ?: 0
        if (ip != 0) {
            return "${ip and 0xFF}.${(ip shr 8) and 0xFF}.${(ip shr 16) and 0xFF}.${(ip shr 24) and 0xFF}"
                .takeIf { it != "0.0.0.0" }
        }
        return NetworkInterface.getNetworkInterfaces().asSequence()
            .flatMap { it.inetAddresses.asSequence() }
            .filterIsInstance<Inet4Address>()
            .firstOrNull { !it.isLoopbackAddress }
            ?.hostAddress
    }
}
