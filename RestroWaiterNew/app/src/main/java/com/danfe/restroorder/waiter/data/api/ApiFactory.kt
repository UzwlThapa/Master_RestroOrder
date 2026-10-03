package com.danfe.restroorder.waiter.data.api

import com.danfe.restroorder.waiter.BuildConfig
import com.danfe.restroorder.waiter.data.local.ServerProfile
import com.danfe.restroorder.waiter.util.ServerUrl
import okhttp3.Cache
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.File
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.TimeUnit
import javax.net.ssl.X509TrustManager

/**
 * Builds one client per server profile (the old app rebuilt its RestAdapter on every call —
 * same effect: address changes apply without reinstall or restart).
 *
 * Production posture for the on-prem dining module:
 *  - timeouts mirror the old Retrofit-1 defaults that actually applied: 15 s connect / 20 s read;
 *    the dead 60 s OkHttpClient in the old SendOrder path is intentionally NOT replicated;
 *  - GETs (menu, room tree) get exponential-backoff retry + a small OkHttp disk cache so a
 *    waiter can still open the menu seconds after reconnecting from dead restaurant Wi-Fi;
 *  - POSTs are never auto-retried (ambiguous legacy semantics); duplicate-send protection lives
 *    in OrderViewModel via send verification;
 *  - logging is the redacting, size-capped interceptor (no BODY-level dumps of passwords/PINs);
 *  - "trust any certificate" is only ever honoured in DEBUG builds. Release builds validate
 *    certificates normally — an on-prem IIS should use a real/CA-issued or properly distributed
 *    internal cert (see docs/ONPREM-IIS.md).
 */
object ApiFactory {

    val gson = com.google.gson.GsonBuilder()
        .serializeSpecialFloatingPointValues()
        .lenient() // legacy JavaScriptSerializer output is not always strict JSON
        .create()

    /** Ring buffer of recent HTTP traffic for the debug log screen (answer #20/21). */
    val httpLog = HttpLogRingBuffer()

    /** Set true (debug builds only, settings screen) to also capture request/response bodies. */
    @Volatile var verboseBodies: Boolean = false

    private val clients = ConcurrentHashMap<String, Pair<ServerProfile, OkHttpClient>>()

    private fun clientFor(profile: ServerProfile): OkHttpClient {
        val cached = clients[profile.id]
        if (cached != null && cached.first == profile) return cached.second

        val builder = OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(20, TimeUnit.SECONDS)
            .writeTimeout(20, TimeUnit.SECONDS)
            .retryOnConnectionFailure(true)
            .addInterceptor(RedactingLogInterceptor({ msg -> httpLog.append(msg) }, logBodies = verboseBodies))
            .addInterceptor(RetryInterceptor())

        // 2 MB disk cache lets menu/room data survive brief connectivity drops entirely offline.
        runCatching { Cache(File(cacheDir(), "http"), 2L * 1024L * 1024L) }
            .getOrNull()?.let { builder.cache(it) }

        if (profile.trustSelfSigned && profile.scheme == "https") {
            if (BuildConfig.DEBUG) {
                builder.applyInsecureTrust()
                httpLog.append("!! TLS validation DISABLED for profile '${profile.name}' (debug build only)")
            } else {
                httpLog.append("!! 'Trust certificate' ignored in release build for '${profile.name}' - fix the server cert instead")
            }
        }

        val client = builder.build()
        clients[profile.id] = profile to client
        return client
    }

    private var cacheRoot: File? = null
    fun initCache(context: android.content.Context) { cacheRoot = context.cacheDir }
    private fun cacheDir(): File = cacheRoot ?: File(System.getProperty("java.io.tmpdir") ?: ".", "restrowaiter-cache")

    fun apiFor(profile: ServerProfile): RestroApi {
        val origin = ServerUrl.origin(profile.scheme, profile.hostPort)
        return Retrofit.Builder()
            .client(clientFor(profile))
            .baseUrl("$origin/") // real URLs are supplied per-call via @Url
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build()
            .create(RestroApi::class.java)
    }

    /** Convenience: the /Modules base for this profile. */
    fun modulesBase(profile: ServerProfile): String =
        ServerUrl.modulesBase(profile.scheme, profile.hostPort, profile.pathPrefix)

    fun servicesBase(profile: ServerProfile): String =
        ServerUrl.servicesBase(profile.scheme, profile.hostPort)

    fun imageUrl(profile: ServerProfile, path: String): String =
        ServerUrl.imageUrl(modulesBase(profile), path)

    private fun OkHttpClient.Builder.applyInsecureTrust(): OkHttpClient.Builder {
        val trustAll = object : X509TrustManager {
            override fun checkClientTrusted(chain: Array<X509Certificate>, authType: String) {}
            override fun checkServerTrusted(chain: Array<X509Certificate>, authType: String) {}
            override fun getAcceptedIssuers(): Array<X509Certificate> = arrayOf()
        }
        val ssl = javax.net.ssl.SSLContext.getInstance("TLS").apply {
            init(null, arrayOf(trustAll), SecureRandom())
        }
        sslSocketFactory(ssl.socketFactory, trustAll)
        hostnameVerifier { _, _ -> true }
        return this
    }
}
