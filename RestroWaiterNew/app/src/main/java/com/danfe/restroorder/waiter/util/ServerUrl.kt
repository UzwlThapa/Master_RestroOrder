package com.danfe.restroorder.waiter.util

/**
 * Builds the server URLs exactly like the old app (helper/Util.java):
 *   modules base = scheme://host[:port]/Modules
 *   services base = scheme://host[:port]/Services  (used only by shiftItems — kept identical, answer #11)
 * The stored profile address is host[:port] with an optional path prefix (default /Modules), answer #13.
 */
object ServerUrl {

    /** e.g. "http://192.168.1.5:8007" or "https://pos.example.com" — no trailing slash. */
    fun origin(scheme: String, hostPort: String): String =
        "${scheme.lowercase()}://${hostPort.trim().trimEnd('/')}"

    fun modulesBase(scheme: String, hostPort: String, pathPrefix: String): String {
        val prefix = pathPrefix.trim().ifBlank { "/Modules" }
        val normalized = if (prefix.startsWith("/")) prefix else "/$prefix"
        return origin(scheme, hostPort) + normalized.trimEnd('/')
    }

    /** Same origin, but "/Services" — mirrors ItemShiftActivity.java:160,292 of the old app. */
    fun servicesBase(scheme: String, hostPort: String): String =
        origin(scheme, hostPort) + "/Services"

    /** Item images: <modulesOrigin>/ROI_Item/ImageItem/<path with %20>. Mirrors the old Picasso usage. */
    fun imageUrl(origin: String, imagePath: String): String =
        origin.trimEnd('/') + "/ROI_Item/ImageItem/" + imagePath.replace(" ", "%20")

    /** Basic validation for the settings screen; returns null when OK, else a friendly message. */
    fun validateHostPort(input: String): String? {
        val v = input.trim()
        if (v.isEmpty()) return "Enter the server address, e.g. 192.168.1.5:8007"
        val hostPort = v.removePrefix("http://").removePrefix("https://").substringBefore('/')
        if (hostPort.isBlank()) return "No host found in \"$input\""
        val host = hostPort.substringBefore(':')
        val portPart = if (hostPort.contains(':')) hostPort.substringAfter(':') else ""
        if (host.isEmpty()) return "Missing host name or IP"
        if (portPart.isNotEmpty() && (portPart.toIntOrNull() == null || portPart.toInt() !in 1..65535))
            return "Invalid port \"$portPart\""
        val hostOk = Regex("^[A-Za-z0-9._\\-]+$").matches(host)
        if (!hostOk) return "\"$host\" is not a valid IP or host name"
        return null
    }
}
