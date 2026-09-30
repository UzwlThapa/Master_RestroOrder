package com.danfe.restroorder.waiter.data.api

import com.danfe.restroorder.waiter.data.local.ServerProfile
import com.danfe.restroorder.waiter.util.ServerUrl
import com.google.gson.GsonBuilder
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.concurrent.TimeUnit
import javax.net.ssl.X509TrustManager

/**
 * Builds one client per server profile (the old app rebuilt its RestAdapter on every call —
 * same effect: address changes apply without reinstall or restart).
 *
 * Timeouts mirror the old Retrofit-1 defaults that actually applied: 15 s connect / 20 s read.
 * The dead 60 s OkHttpClient in the old SendOrder path is intentionally NOT replicated.
 */
object ApiFactory {

    val gson = GsonBuilder().serializeSpecialFloatingPointValues().create()

    /** Ring buffer of recent HTTP traffic for the debug log screen (answer #20/21). */
    val httpLog = HttpLogRingBuffer()

    private val baseClient: OkHttpClient by lazy {
        val logging = HttpLoggingInterceptor { msg -> httpLog.append(msg) }
            .apply { level = HttpLoggingInterceptor.Level.BODY }
        OkHttpClient.Builder()
            .connectTimeout(15, TimeUnit.SECONDS)
            .readTimeout(20, TimeUnit.SECONDS)
            .addInterceptor(logging)
            .build()
    }

    fun apiFor(profile: ServerProfile): RestroApi {
        val client = if (profile.trustSelfSigned && profile.scheme == "https")
            baseClient.newBuilder().applyInsecureTrust().build()
        else baseClient

        val origin = ServerUrl.origin(profile.scheme, profile.hostPort)
        return Retrofit.Builder()
            .client(client)
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
