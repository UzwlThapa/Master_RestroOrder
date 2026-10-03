package com.danfe.restroorder.waiter.data.api

import okhttp3.Interceptor
import okhttp3.Response
import java.io.IOException
import java.net.ProtocolException
import java.net.SocketException
import java.net.SocketTimeoutException
import javax.net.ssl.SSLException

/**
 * Exponential-backoff retry for SAFE, idempotent requests only (the GETs: menu / room tree).
 * Mutations (PurchaseOrder etc.) are NEVER retried here — a timeout on a POST against the legacy
 * ASMX server is ambiguous (the order may already be in the DB), so resending is handled at the
 * ViewModel level via verification instead.
 *
 * Runs on OkHttp's IO thread, so a plain sleep is correct here (no coroutines involved).
 * Tuned for laggy restaurant Wi-Fi: 4 attempts total, ~0.5 s / 1 s / 2 s backoff (+jitter).
 */
class RetryInterceptor(
    private val maxAttempts: Int = 4,
    private val baseDelayMs: Long = 500,
) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val req = chain.request()
        val safe = req.method == "GET"
        var attempt = 0
        while (true) {
            attempt++
            try {
                val resp = chain.proceed(req)
                // 5xx from IIS during app-pool recycles / throttling: worth another try for GETs.
                if (safe && resp.code in 500..599 && attempt < maxAttempts) {
                    resp.close()
                    sleepBackoff(attempt)
                    continue
                }
                return resp
            } catch (e: IOException) {
                if (!safe || !isRetryable(e) || attempt >= maxAttempts) throw e
                sleepBackoff(attempt)
            }
        }
    }

    private fun isRetryable(e: IOException): Boolean = when (e) {
        is SocketTimeoutException, is ProtocolException, is SocketException -> true
        // SSLException can wrap connection resets; real handshake failures fail identically on retry,
        // but they surface fast enough that one extra attempt is harmless and keeps flaky-Wi-Fi flows up.
        is SSLException -> true
        else -> e.message?.contains("Connection reset", ignoreCase = true) == true
    }

    private fun sleepBackoff(attempt: Int) {
        val d = baseDelayMs shl (attempt - 1).coerceAtMost(3)
        try {
            Thread.sleep(d + (Math.random() * 250).toLong())
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
        }
    }
}
