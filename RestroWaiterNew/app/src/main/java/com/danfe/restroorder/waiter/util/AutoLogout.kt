package com.danfe.restroorder.waiter.util

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import com.danfe.restroorder.waiter.App
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * Keeps the old app's behaviour (answer #6): auto-logout when the screen turns off,
 * and after 30 minutes without user interaction. No device-admin lock (dropped).
 */
object AutoLogout {
    private const val IDLE_MS = 30L * 60L * 1000L

    private var lastInteraction = System.currentTimeMillis()
    private var idleJob: Job? = null

    fun init(app: App) {
        // Any activity resume counts as interaction; touch resets the timer via Activity callbacks below.
        ProcessLifecycleOwner.get().lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onResume(owner: LifecycleOwner) {
                lastInteraction = System.currentTimeMillis()
                startIdleWatch(app)
            }

            override fun onStop(owner: LifecycleOwner) {
                // Whole app went to background / screen off -> log out like LogoutService did.
                logout(app)
            }
        })

        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                if (intent.action == Intent.ACTION_SCREEN_OFF) logout(app)
            }
        }
        app.registerReceiver(receiver, IntentFilter(Intent.ACTION_SCREEN_OFF))
    }

    fun touch() { lastInteraction = System.currentTimeMillis() }

    private fun startIdleWatch(app: App) {
        if (idleJob?.isActive == true) return
        idleJob = app.appScope.launch {
            while (true) {
                delay(30_000)
                if (System.currentTimeMillis() - lastInteraction > IDLE_MS) {
                    logout(app)
                    break
                }
            }
        }
    }

    private fun logout(app: App) {
        app.appScope.launch { app.session.forceLogout() }
    }
}
