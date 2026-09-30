package com.restroorder.waiter

import android.annotation.SuppressLint
import android.content.Context
import android.os.Bundle
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.view.WindowManager
import android.webkit.*
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.work.*
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.restroorder.waiter.bridge.WaiterAppBridge
import com.restroorder.waiter.data.AppDatabase
import com.restroorder.waiter.databinding.ActivityMainBinding
import com.restroorder.waiter.network.ApiClient
import com.restroorder.waiter.worker.StatusPollerWorker
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch
import java.util.concurrent.TimeUnit
import javax.inject.Inject

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private lateinit var webView: WebView

    @Inject
    lateinit var apiClient: ApiClient

    @Inject
    lateinit var database: AppDatabase

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // F4.5: Keep screen on during shift
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        setupWebView()
        setupBottomNav()
        scheduleStatusPoller()
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView() {
        webView = binding.webView
        val settings = webView.settings
        settings.javaScriptEnabled = true
        settings.domStorageEnabled = true
        settings.useWideViewPort = true
        settings.loadWithOverviewMode = true
        settings.setSupportZoom(false)
        settings.builtInZoomControls = false
        settings.displayZoomControls = false

        // Shared Cookie Persistence (ASP.NET_SessionId)
        val cookieManager = CookieManager.getInstance()
        cookieManager.setAcceptCookie(true)
        cookieManager.setAcceptThirdPartyCookies(webView, true)

        // Add Native Waiter JS Bridge
        val bridge = WaiterAppBridge(
            context = this,
            onOrderCaptured = { cartJson ->
                lifecycleScope.launch {
                    apiClient.processOrQueueOrder(cartJson)
                }
            },
            onPrintRequested = { html, role ->
                lifecycleScope.launch {
                    apiClient.enqueuePrintJob(html, role)
                }
            }
        )
        webView.addJavascriptInterface(bridge, "WaiterApp")

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                val url = request?.url?.toString() ?: return false
                // F3.3: Session expiry watchdog
                if (url.contains("/Login.aspx") || url.contains("ReturnUrl=")) {
                    handleSessionExpired()
                    return true
                }
                return false
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view)
                injectBridgeShim()
            }
        }

        // Load initial dining module
        val baseUrl = apiClient.getBaseUrl()
        val pageId = apiClient.getDiningPageId()
        webView.loadUrl("$baseUrl/Default.aspx?id=$pageId")
    }

    private fun injectBridgeShim() {
        // Read bridge_shim.js from assets and evaluate in WebView context
        try {
            val shim = assets.open("bridge_shim.js").bufferedReader().use { it.readText() }
            webView.evaluateJavascript(shim, null)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun handleSessionExpired() {
        Toast.makeText(this, "Session expired, performing silent re-auth...", Toast.LENGTH_SHORT).show()
        lifecycleScope.launch {
            val restored = apiClient.silentReLogin()
            if (restored) {
                webView.reload()
            } else {
                Toast.makeText(this@MainActivity, "Please enter your PIN again", Toast.LENGTH_LONG).show()
            }
        }
    }

    private fun setupBottomNav() {
        val navView: BottomNavigationView = binding.bottomNav
        navView.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.tab_dining -> {
                    binding.viewFlipper.displayedChild = 0
                    true
                }
                R.id.tab_orders -> {
                    binding.viewFlipper.displayedChild = 1
                    true
                }
                R.id.tab_bills -> {
                    binding.viewFlipper.displayedChild = 2
                    true
                }
                R.id.tab_prints -> {
                    binding.viewFlipper.displayedChild = 3
                    true
                }
                R.id.tab_more -> {
                    binding.viewFlipper.displayedChild = 4
                    true
                }
                else -> false
            }
        }
    }

    private fun scheduleStatusPoller() {
        val constraints = Constraints.Builder()
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val pollWork = PeriodicWorkRequestBuilder<StatusPollerWorker>(
            repeatInterval = 20, TimeUnit.SECONDS
        )
            .setConstraints(constraints)
            .build()

        WorkManager.getInstance(this).enqueueUniquePeriodicWork(
            "KitchenStatusPoller",
            ExistingPeriodicWorkPolicy.UPDATE,
            pollWork
        )
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        if (binding.viewFlipper.displayedChild == 0 && webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }
}
