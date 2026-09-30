package com.danfe.restroorder.waiter.ui.login

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.local.ServerProfile
import com.danfe.restroorder.waiter.data.repository.AuthRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class LoginViewModel(private val app: App) : ViewModel() {

    private val auth = AuthRepository(app, app.session)

    data class Ui(
        val busy: Boolean = false,
        val error: String? = null,
        val alreadyLoggedInElsewhere: Boolean = false,
        val success: Boolean = false,
        val profiles: List<ServerProfile> = emptyList(),
        val activeProfile: ServerProfile? = null,
    )

    private val _ui = MutableStateFlow(Ui())
    val ui: StateFlow<Ui> = _ui

    init {
        viewModelScope.launch {
            val snap = app.prefs.snapshotOnce()
            val active = snap.profiles.firstOrNull { it.id == snap.activeProfileId } ?: snap.profiles.firstOrNull()
            _ui.value = _ui.value.copy(profiles = snap.profiles, activeProfile = active)
        }
    }

    fun loginPin(pin: String) {
        val profile = _ui.value.activeProfile ?: run {
            _ui.value = _ui.value.copy(error = "No server selected. Add one below first.")
            return
        }
        _ui.value = _ui.value.copy(busy = true, error = null)
        viewModelScope.launch {
            try {
                val resp = auth.loginPin(profile, pin)
                val d = resp.data
                if (d?.userName.isNullOrBlank()) {
                    _ui.value = _ui.value.copy(busy = false, error = d?.message ?: resp.message ?: "Wrong PIN")
                    return@launch
                }
                app.session.onLoginSuccess(
                    profile = profile, username = d!!.userName!!, userId = d.userId ?: "",
                    roles = d.roles ?: "", pin = pin, disablePin = d.disablePin == true,
                )
                _ui.value = _ui.value.copy(busy = false, success = true)
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(busy = false, error = AuthRepository.friendly(e))
            }
        }
    }

    fun loginPassword(username: String, password: String) {
        val profile = _ui.value.activeProfile ?: run {
            _ui.value = _ui.value.copy(error = "No server selected. Add one below first.")
            return
        }
        _ui.value = _ui.value.copy(busy = true, error = null)
        viewModelScope.launch {
            try {
                val resp = auth.checkLogin(profile, username, password)
                val status = resp.status?.trim('"') // server returns JSON-quoted strings sometimes
                when {
                    status.equals("Success", true) -> {
                        app.session.onLoginSuccess(
                            profile = profile, username = resp.username ?: username,
                            userId = resp.userId ?: "", roles = resp.roleNames ?: "",
                            pin = "", disablePin = false,
                        )
                        _ui.value = _ui.value.copy(busy = false, success = true)
                    }
                    status.equals("LoggedIn", true) ->
                        _ui.value = _ui.value.copy(busy = false, alreadyLoggedInElsewhere = true, error = null)
                    else ->
                        _ui.value = _ui.value.copy(busy = false, error = "Login failed (${resp.status ?: "no response"})")
                }
            } catch (e: Exception) {
                _ui.value = _ui.value.copy(busy = false, error = AuthRepository.friendly(e))
            }
        }
    }

    fun dismissAlreadyLoggedIn() {
        _ui.value = _ui.value.copy(alreadyLoggedInElsewhere = false)
    }

    fun selectProfile(p: ServerProfile) {
        viewModelScope.launch {
            app.session.switchProfile(p)
            _ui.value = _ui.value.copy(activeProfile = p)
        }
    }
}
