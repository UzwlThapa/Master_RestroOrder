package com.restroorder.waiter.printer

import android.content.Context
import android.util.Base64
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.OutputStream
import java.net.InetSocketAddress
import java.net.Socket

class EscPosPrinterService(private val context: Context) {

    // ESC/POS Commands
    companion object {
        val ESC_INIT = byteArrayOf(0x1B, 0x40)
        val ESC_ALIGN_CENTER = byteArrayOf(0x1B, 0x61, 0x01)
        val ESC_ALIGN_LEFT = byteArrayOf(0x1B, 0x61, 0x00)
        val ESC_BOLD_ON = byteArrayOf(0x1B, 0x45, 0x01)
        val ESC_BOLD_OFF = byteArrayOf(0x1B, 0x45, 0x00)
        val ESC_CUT = byteArrayOf(0x1D, 0x56, 0x41, 0x10) // Cut full
        val ESC_DRAWER_KICK = byteArrayOf(0x1B, 0x70, 0x00, 0x19, 0xFA.toByte())
    }

    suspend fun printOverTcp(ip: String, port: Int = 9100, slipText: String): PrintResult = withContext(Dispatchers.IO) {
        try {
            Socket().use { socket ->
                socket.connect(InetSocketAddress(ip, port), 3000)
                socket.soTimeout = 3000

                // Query status byte first (Epson DLE EOT 1)
                val out: OutputStream = socket.getOutputStream()
                out.write(ESC_INIT)
                out.write(slipText.toByteArray(Charsets.UTF_8))
                out.write(ESC_CUT)
                out.flush()
                return@withContext PrintResult.Success
            }
        } catch (e: Exception) {
            val reason = when {
                e.message?.contains("refused", true) == true -> "OFFLINE"
                e.message?.contains("timeout", true) == true -> "TIMEOUT"
                else -> "NETWORK_ERROR"
            }
            return@withContext PrintResult.Failure(reason, e.localizedMessage ?: "Unknown error")
        }
    }
}

sealed class PrintResult {
    object Success : PrintResult()
    data class Failure(val code: String, val error: String) : PrintResult()
}
