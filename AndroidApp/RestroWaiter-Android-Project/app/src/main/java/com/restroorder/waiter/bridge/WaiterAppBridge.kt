package com.restroorder.waiter.bridge

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.webkit.JavascriptInterface
import android.widget.Toast

class WaiterAppBridge(
    private val context: Context,
    private val onOrderCaptured: (String) -> Unit,
    private val onPrintRequested: (String, String) -> Unit
) {

    @JavascriptInterface
    fun captureOrder(cartJson: String) {
        onOrderCaptured(cartJson)
    }

    @JavascriptInterface
    fun print(html: String, role: String) {
        onPrintRequested(html, role)
    }

    @JavascriptInterface
    fun toast(msg: String) {
        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show()
    }

    @JavascriptInterface
    fun vibrate(durationMs: Long) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator.vibrate(
                VibrationEffect.createOneShot(durationMs, VibrationEffect.DEFAULT_AMPLITUDE)
            )
        } else {
            @Suppress("DEPRECATION")
            val v = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            @Suppress("DEPRECATION")
            v.vibrate(durationMs)
        }
    }

    @JavascriptInterface
    fun openDrawer() {
        // Kick cash drawer via thermal printer ESC/POS pulse
        onPrintRequested("\u001Bp\u0000\u0019\u00FA", "BILL")
        toast("Cash drawer opened")
    }

    @JavascriptInterface
    fun getAppVersion(): String {
        return "1.0.4-native"
    }
}
