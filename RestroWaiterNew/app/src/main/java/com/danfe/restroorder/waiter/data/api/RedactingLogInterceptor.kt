package com.danfe.restroorder.waiter.data.api

import okhttp3.Interceptor
import okhttp3.Response

/**
 * Redacting, size-capped HTTP logger feeding the in-app debug ring buffer.
 *
 * Replaces HttpLoggingInterceptor.Level.BODY on the hot path:
 *  - never keeps megabyte request/response bodies in memory (low-end devices, slow LAN),
 *  - masks credentials (password / pin / json payloads containing them) before storing,
 *  - truncates every logged line to a hard cap.
 */
class RedactingLogInterceptor(
    private val sink: (String) -> Unit,
    private val maxLine: Int = 400,
    private val logBodies: Boolean = false,
) : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        val req = chain.request()
        // Body capture is opt-in only: reading bodies costs memory on low-end devices, so by
        // default we log method/URL/status/latency — enough to debug slow-network issues.
        val bodyText = if (logBodies) runCatching { req.body?.let { b ->
            val buffer = okio.Buffer(); b.writeTo(buffer)
            buffer.readUtf8().take(maxLine)
        } }.getOrNull() else null
        val url = redact(req.url.toString())
        sink(cap("--> ${req.method} $url" + (bodyText?.let { " body=${redact(it)}" } ?: "")))
        val t0 = System.currentTimeMillis()
        return try {
            val resp = chain.proceed(req)
            var snippet: String? = null
            if (logBodies) {
                val peeked = resp.peekBody(MAX_PEEK_BYTES)
                snippet = runCatching { redact(peeked.string()).take(maxLine) }.getOrNull()
            }
            sink(cap("<-- ${resp.code} ${req.method} ${req.url.encodedPath} (${System.currentTimeMillis() - t0} ms)" + (snippet?.let { " $it" } ?: "")))
            resp
        } catch (e: Exception) {
            sink(cap("<-- FAILED ${req.method} ${req.url.encodedPath}: ${e.javaClass.simpleName} (${System.currentTimeMillis() - t0} ms)"))
            throw e
        }
    }

    private val MAX_PEEK_BYTES = 8L * 1024L

    private fun cap(line: String): String =
        if (line.length <= maxLine) line else line.take(maxLine) + "…"

    companion object {
        /** Best-effort masking of credential-looking values in any logged text. */
        fun redact(text: String): String = text
            .replace(Regex("""(?i)("(?:password|pin)"\s*:\s*)"[^"]*""""), "$1\"****\"")
            .replace(Regex("""(?i)((?:password|pin)=)[^&\s"]*"""), "$1****")
    }
}
