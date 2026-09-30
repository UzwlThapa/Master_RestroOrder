package com.danfe.restroorder.waiter.data.repository

import android.content.Context
import com.danfe.restroorder.waiter.data.api.ApiFactory
import com.danfe.restroorder.waiter.data.local.FeatureFlags
import com.danfe.restroorder.waiter.data.local.PrefsStore
import com.danfe.restroorder.waiter.data.local.ServerProfile
import com.danfe.restroorder.waiter.util.waiterIp
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

/**
 * In-memory session. The backend has NO cookies/tokens (Step-1 section 1): identity is
 * username + WaiterIP, and sensitive actions re-check the 4-digit PIN via CheckPin.
 * We keep exactly that model: the PIN entered at login is retained so subsequent
 * CheckPin calls can use it, mirroring helper/CheckPinCode.java behaviour.
 */
class Session(private val prefs: PrefsStore) {

    private val _state = MutableStateFlow(SessionState())
    val state: StateFlow<SessionState> = _state

    data class SessionState(
        val loggedIn: Boolean = false,
        val username: String = "",
        val userId: String = "",
        val roles: String = "",
        val pin: String = "",
        val disablePin: Boolean = false,
        val activeProfile: ServerProfile? = null,
        val featureFlags: FeatureFlags = FeatureFlags(),
    )

    suspend fun restore(username: String, userId: String, roles: String, pin: String, disablePin: Boolean) {
        val snap = prefs.snapshotOnce()
        val active = snap.profiles.firstOrNull { it.id == snap.activeProfileId } ?: snap.profiles.firstOrNull()
        _state.value = SessionState(
            loggedIn = active != null && username.isNotBlank(),
            username = username, userId = userId, roles = roles, pin = pin,
            disablePin = disablePin, activeProfile = active,
            featureFlags = prefs.featureFlags(),
        )
    }

    suspend fun onLoginSuccess(
        profile: ServerProfile, username: String, userId: String,
        roles: String, pin: String, disablePin: Boolean,
    ) {
        prefs.saveSession(username, userId, roles, pin, disablePin)
        _state.value = _state.value.copy(
            loggedIn = true, username = username, userId = userId, roles = roles,
            pin = pin, disablePin = disablePin, activeProfile = profile,
            featureFlags = prefs.featureFlags(),
        )
    }

    suspend fun forceLogout() {
        if (!_state.value.loggedIn) return
        val u = _state.value.username
        val profile = _state.value.activeProfile
        if (profile != null && u.isNotBlank()) {
            runCatching {
                // Same LoggedOut call as the old app: json={username}
                val body = ApiFactory.gson.toJson(mapOf("username" to u))
                ApiFactory.apiFor(profile).loggedOut(
                    "${ApiFactory.modulesBase(profile)}/ROUSER/ROLoginWebService.asmx/LoggedOut", body
                )
            }
        }
        prefs.clearSession()
        _state.value = SessionState(activeProfile = profile, featureFlags = _state.value.featureFlags)
    }

    /** Update the live feature flags after saving them in Settings. */
    suspend fun forceFlags(flags: FeatureFlags) {
        _state.value = _state.value.copy(featureFlags = flags)
    }

    suspend fun switchProfile(profile: ServerProfile?) {
        prefs.setActiveProfile(profile?.id ?: "")
        _state.value = _state.value.copy(activeProfile = profile)
    }

    /** URL bound to the active profile — every repository call goes through these. */
    fun modulesUrl(path: String): String =
        "${ApiFactory.modulesBase(requireProfile())}/$path"

    /** /Services base — only used by shiftItems, kept identical (answer #11). */
    fun servicesUrl(path: String): String =
        "${ApiFactory.servicesBase(requireProfile())}/$path"

    fun api(): com.danfe.restroorder.waiter.data.api.RestroApi =
        ApiFactory.apiFor(requireProfile())

    fun requireProfile(): ServerProfile =
        _state.value.activeProfile ?: error("No server profile selected. Open Settings and add a server.")

    fun waiterIp(ctx: Context): String = waiterIp(ctx)
}
