package com.danfe.restroorder.waiter.ui.settings

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.local.FeatureFlags
import com.danfe.restroorder.waiter.data.local.ServerProfile
import com.danfe.restroorder.waiter.data.repository.AuthRepository
import com.danfe.restroorder.waiter.util.LanScanner
import com.danfe.restroorder.waiter.util.ServerUrl
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

/**
 * Settings: multiple named server profiles (LAN IP / https domain), http|https toggle, path prefix,
 * optional trust-self-signed per profile, Test connection, QR scan + LAN auto-discovery helpers,
 * and the feature on/off switches kept from the old app.
 */
class SettingsViewModel(private val app: App) : ViewModel() {

    data class Ui(
        val profiles: List<ServerProfile> = emptyList(),
        val activeId: String = "",
        val testing: Boolean = false,
        val testResult: String? = null,
        val scanning: Boolean = false,
        val discovered: List<LanScanner.Found> = emptyList(),
        val flags: FeatureFlags = FeatureFlags(),
        val saved: Boolean = false,
    )

    private val _ui = MutableStateFlow(Ui())
    val ui: StateFlow<Ui> = _ui

    init {
        viewModelScope.launch {
            val s = app.prefs.snapshotOnce()
            _ui.value = _ui.value.copy(profiles = s.profiles, activeId = s.activeProfileId, flags = app.prefs.featureFlags())
        }
    }

    fun addProfile(name: String, address: String, https: Boolean, prefix: String, trustCert: Boolean) {
        val err = ServerUrl.validateHostPort(address)
        if (err != null) { _ui.value = _ui.value.copy(testResult = err); return }
        val clean = address.trim().removePrefix("http://").removePrefix("https://")
        val p = ServerProfile(
            id = System.currentTimeMillis().toString(),
            name = name.ifBlank { "Server" },
            scheme = if (https) "https" else "http",
            hostPort = clean,
            pathPrefix = prefix.ifBlank { "/Modules" },
            trustSelfSigned = trustCert,
        )
        val list = _ui.value.profiles + p
        viewModelScope.launch {
            app.prefs.saveProfiles(list)
            _ui.value = _ui.value.copy(profiles = list, saved = true)
        }
    }

    fun updateProfile(p: ServerProfile) {
        val list = _ui.value.profiles.map { if (it.id == p.id) p else it }
        viewModelScope.launch {
            app.prefs.saveProfiles(list)
            _ui.value = _ui.value.copy(profiles = list, saved = true)
        }
    }

    fun deleteProfile(id: String) {
        val list = _ui.value.profiles.filter { it.id != id }
        viewModelScope.launch {
            app.prefs.saveProfiles(list)
            if (_ui.value.activeId == id) app.session.switchProfile(list.firstOrNull())
            _ui.value = _ui.value.copy(profiles = list, activeId = if (_ui.value.activeId == id) list.firstOrNull()?.id ?: "" else _ui.value.activeId)
        }
    }

    fun activate(id: String) {
        viewModelScope.launch {
            val p = _ui.value.profiles.firstOrNull { it.id == id }
            app.session.switchProfile(p)
            _ui.value = _ui.value.copy(activeId = id)
        }
    }

    fun test(id: String) {
        val p = _ui.value.profiles.firstOrNull { it.id == id } ?: return
        _ui.value = _ui.value.copy(testing = true, testResult = null)
        viewModelScope.launch {
            val r = AuthRepository(app, app.session).testConnection(p)
            _ui.value = _ui.value.copy(
                testing = false,
                testResult = when (r) {
                    is AuthRepository.TestResult.Pass -> "✔ $id reachable"
                    is AuthRepository.TestResult.Fail -> "✖ ${r.reason}"
                },
            )
        }
    }

    /** Scan a QR containing e.g. http://192.168.1.5:8007 — result arrives via callback from the UI. */
    fun applyScanned(text: String) {
        val t = text.trim()
        val https = t.startsWith("https://")
        var hostPort = t.removePrefix("http://").removePrefix("https://").trimEnd('/')
        // Strip any path the QR may carry (e.g. http://host/Modules) — profile stores host[:port] only.
        val slash = hostPort.indexOf('/')
        if (slash >= 0) hostPort = hostPort.substring(0, slash)
        val err = ServerUrl.validateHostPort(hostPort)
        _ui.value = _ui.value.copy(testResult = err ?: "Scanned: $hostPort")
        if (err == null) {
            val existing = _ui.value.profiles.firstOrNull { it.hostPort.equals(hostPort, true) }
            if (existing != null) {
                updateProfile(existing.copy(scheme = if (https) "https" else "http"))
                _ui.value = _ui.value.copy(testResult = "✔ Existing server \"${existing.name}\" updated to ${if (https) "HTTPS" else "HTTP"}: $hostPort")
            } else {
                addProfile("Scanned", hostPort, https, "/Modules", trustCert = false)
            }
        }
    }

    fun startLanScan(ports: List<Int>, https: Boolean) {
        _ui.value = _ui.value.copy(scanning = true, discovered = emptyList())
        viewModelScope.launch {
            LanScanner.scan(app, ports, https, "/Modules") { found ->
                _ui.value = _ui.value.copy(discovered = _ui.value.discovered + found)
            }
            _ui.value = _ui.value.copy(scanning = false)
        }
    }

    fun useDiscovered(f: LanScanner.Found) {
        addProfile("Found ${f.address}", f.address, https = false, "/Modules", trustCert = false)
    }

    fun setFlag(update: (FeatureFlags) -> FeatureFlags) {
        val new = update(_ui.value.flags)
        viewModelScope.launch {
            app.prefs.setFeatureFlags(new)
            // reflect into live session immediately
            app.session.forceFlags(new)
            _ui.value = _ui.value.copy(flags = new)
        }
    }

    fun consumeSaved() { _ui.value = _ui.value.copy(saved = false) }
}
