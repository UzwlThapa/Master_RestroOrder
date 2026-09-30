package com.danfe.restroorder.waiter

import android.app.Application
import com.danfe.restroorder.waiter.data.local.PrefsStore
import com.danfe.restroorder.waiter.data.repository.Session
import com.danfe.restroorder.waiter.util.AutoLogout
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

class App : Application() {
    val prefs by lazy { PrefsStore(this) }
    val session by lazy { Session(prefs) }
    val appScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    override fun onCreate() {
        super.onCreate()
        // Auto-logout on screen-off and 30 min idle (kept from the old app).
        AutoLogout.init(this)
        appScope.launch { restoreSession() }
    }

    /** Rehydrate the in-memory session from persisted login data so a restart does not drop the waiter out. */
    private suspend fun restoreSession() {
        val s = prefs.snapshotOnce()
        if (s.lastUsername.isNotBlank()) {
            session.restore(
                username = s.lastUsername,
                userId = s.lastUserId,
                roles = s.lastRoles,
                pin = s.lastPin,
                disablePin = s.lastDisablePin,
            )
        }
    }
}
