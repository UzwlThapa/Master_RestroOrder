package com.danfe.restroorder.waiter.data.local

import android.content.Context
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map

private val Context.dataStore by preferencesDataStore(name = "waiter_prefs")

data class ServerProfile(
    val id: String,
    val name: String,          // e.g. "Main Branch", "Cloud"
    val scheme: String,        // "http" | "https"
    val hostPort: String,      // raw host[:port], same value the old app stored in baseUrl
    val pathPrefix: String,    // default "/Modules" (answer #13)
    val trustSelfSigned: Boolean = false, // per-profile option (answer #12)
)

data class PrefsSnapshot(
    val profiles: List<ServerProfile> = emptyList(),
    val activeProfileId: String = "",
    val lastUsername: String = "",
    val lastUserId: String = "",
    val lastRoles: String = "",
    val lastPin: String = "",
    val lastDisablePin: Boolean = false,
    val featureFlagsJson: String = "{}",
)

class PrefsStore(private val ctx: Context) {
    private val gson = Gson()
    private val kProfiles = stringPreferencesKey("profiles")
    private val kActive = stringPreferencesKey("active_profile")
    private val kUser = stringPreferencesKey("last_username")
    private val kUserId = stringPreferencesKey("last_user_id")
    private val kRoles = stringPreferencesKey("last_roles")
    private val kPin = stringPreferencesKey("last_pin")
    private val kDisablePin = booleanPreferencesKey("disable_pin")
    private val kFlags = stringPreferencesKey("feature_flags")

    val snapshots: Flow<PrefsSnapshot> = ctx.dataStore.data.map { prefs ->
        PrefsSnapshot(
            profiles = decodeProfiles(prefs[kProfiles]),
            activeProfileId = prefs[kActive] ?: "",
            lastUsername = prefs[kUser] ?: "",
            lastUserId = prefs[kUserId] ?: "",
            lastRoles = prefs[kRoles] ?: "",
            lastPin = prefs[kPin] ?: "",
            lastDisablePin = prefs[kDisablePin] ?: false,
            featureFlagsJson = prefs[kFlags] ?: "{}",
        )
    }

    suspend fun snapshotOnce(): PrefsSnapshot = snapshots.first()

    private fun decodeProfiles(json: String?): List<ServerProfile> {
        if (json.isNullOrBlank()) return emptyList()
        val type = object : TypeToken<List<ServerProfile>>() {}.type
        return runCatching { gson.fromJson<List<ServerProfile>>(json, type) }.getOrNull() ?: emptyList()
    }

    suspend fun saveProfiles(profiles: List<ServerProfile>) {
        ctx.dataStore.edit { it[kProfiles] = gson.toJson(profiles) }
    }

    suspend fun setActiveProfile(id: String) {
        ctx.dataStore.edit { it[kActive] = id }
    }

    suspend fun saveSession(username: String, userId: String, roles: String, pin: String, disablePin: Boolean) {
        ctx.dataStore.edit {
            it[kUser] = username
            it[kUserId] = userId
            it[kRoles] = roles
            it[kPin] = pin
            it[kDisablePin] = disablePin
        }
    }

    suspend fun clearSession() {
        ctx.dataStore.edit {
            it.remove(kUser); it.remove(kUserId); it.remove(kRoles); it.remove(kPin); it.remove(kDisablePin)
        }
    }

    suspend fun setFeatureFlags(flags: FeatureFlags) {
        ctx.dataStore.edit { it[kFlags] = gson.toJson(flags) }
    }

    suspend fun featureFlags(): FeatureFlags {
        val json = snapshots.first().featureFlagsJson
        return runCatching { gson.fromJson(json, FeatureFlags::class.java) }
            .getOrNull() ?: FeatureFlags()
    }
}

/** On/off switches kept from the old settings screen (answer #7). */
data class FeatureFlags(
    val splitBill: Boolean = true,
    val mergeTables: Boolean = true,
    val unmergeTables: Boolean = true,
    val shiftTable: Boolean = true,
    val shiftItems: Boolean = true,
    val showBill: Boolean = true,
    val cancelOrder: Boolean = true,
    val outOfStockToggle: Boolean = true,
    val payBill: Boolean = true,
)
