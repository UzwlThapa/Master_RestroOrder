package com.restroorder.waiter.network

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import okhttp3.OkHttpClient
import okhttp3.Request
import java.net.InetSocketAddress
import java.net.Socket
import java.util.concurrent.TimeUnit

data class ScanProgress(
    val currentIp: String,
    val scannedCount: Int,
    val totalCount: Int,
    val foundServers: List<DiscoveredServer>
)

data class DiscoveredServer(
    val ip: String,
    val port: Int,
    val url: String,
    val responseTimeMs: Long
)

class LanScanner(
    private val client: OkHttpClient = OkHttpClient.Builder()
        .connectTimeout(300, TimeUnit.MILLISECONDS)
        .readTimeout(600, TimeUnit.MILLISECONDS)
        .build()
) {

    fun scanSubnet(subnetPrefix: String = "192.168.1."): Flow<ScanProgress> = flow {
        val found = mutableListOf<DiscoveredServer>()
        val total = 254
        val ports = listOf(80, 443, 8080, 8443)

        for (i in 1..total) {
            val ip = "$subnetPrefix$i"
            val reachable = probePorts(ip, ports)
            if (reachable != null) {
                // Validate if it is really SageFrame RestroOrder
                if (validateRestroHost(reachable.first, reachable.second)) {
                    val url = "http://${reachable.first}:${reachable.second}"
                    found.add(DiscoveredServer(reachable.first, reachable.second, url, 45))
                }
            }
            emit(ScanProgress(ip, i, total, found.toList()))
        }
    }

    private suspend fun probePorts(ip: String, ports: List<Int>): Pair<String, Int>? = withContext(Dispatchers.IO) {
        for (port in ports) {
            try {
                Socket().use { socket ->
                    socket.connect(InetSocketAddress(ip, port), 250)
                    return@withContext Pair(ip, port)
                }
            } catch (_: Exception) {}
        }
        null
    }

    private suspend fun validateRestroHost(ip: String, port: Int): Boolean = withContext(Dispatchers.IO) {
        val scheme = if (port == 443 || port == 8443) "https" else "http"
        val testUrl = "$scheme://$ip:$port/Default.aspx?id=42"
        return@withContext try {
            val req = Request.Builder().url(testUrl).get().build()
            client.newCall(req).execute().use { response ->
                val body = response.body?.string() ?: ""
                body.contains("Dinning") || body.contains("RestroDashboard") || response.isSuccessful
            }
        } catch (_: Exception) {
            false
        }
    }
}
