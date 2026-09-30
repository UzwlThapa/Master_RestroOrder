--- PHASE1_IMPLEMENTATION_PLAN.md (原始)


+++ PHASE1_IMPLEMENTATION_PLAN.md (修改后)
# RestroWaiter — PHASE 1 IMPLEMENTATION PLAN (Concrete, verified against the repo)

Scope decision: **Phase 1 = WebView shell + server profiles/QR provisioning + native TCP ESC/POS printing + print-status history + diagnostics.**
Offline order queueing and live order-status alerts are **deferred to Phase 2** because of two verified risks (see §0).

---

## 0. Risk findings from the actual code (why we defer offline-queue & 20s polling)

| Claim in WAITER_APP_SPEC.md | Reality in repo | Consequence / fix |
|---|---|---|
| Replay `SaveSalesBill` offline on reconnect | `DinningJS.js:2621-2625` posts `{salesMaster, salesDetail, splited, billingTerm, flatorperdiscount}` with `salesMaster.SalesMasterId` unset and per-line `OrderDetailsID`; `.asmx` inserts new rows every call. No client key exists. | **Duplicates guaranteed** if a save times out and is retried. Fix first: add idempotency (§7.1) before enabling any replay. |
| "Background poll every 20 s" via WorkManager | WorkManager minimum periodic interval ≈ 15 min; foreground service is killable on OEM Android 12+. | Replace with **in-page JS heartbeat** (`setInterval` → `checkOrder`, `DinningJS.js:543`) that calls back into the app only when status changes; app keeps one screen-on foreground service while the dining tab is open. |
| Intercept AJAX for offline queue | All traffic goes through one funnel: `DashboardFunction.ajaxCall` (`DinningJS.js:68 async:false`, `:331`). It's jQuery XHR inside the page — **not interceptable from OkHttp/WebView network layer**. | Do interception **in JavaScript**, injected via `evaluateJavascript` at `onPageFinished`, hooking `DashboardFunction.ajaxCall` only. Single choke point = safe patch. |
| HSTS `includeSubDomains; preload` breaks self-signed | Confirmed in root `web.config`. | Phase 1 ships a **NetworkSecurityConfig trusting one LAN CA** (§5.4) + docs to import it on tablets. Long term: real cert (Let's Encrypt DNS-01 for LAN hostnames). |

Good news that de-risks everything else: `async:false` means responses arrive synchronously in-page, so an injected JS hook can queue/retry **without breaking UI flow**, and `savePrintCount` (`DinningJS.js:809-814`) already gives us a server-side print audit trail to reconcile against.

---

## 1. Android project structure (Kotlin, minSdk 24, targetSdk 34)

```
RestroWaiter/
├─ settings.gradle.kts  build.gradle.kts  gradle/libs.versions.toml
└─ app/
   ├─ build.gradle.kts                  # deps below
   └─ src/main/
      ├─ AndroidManifest.xml
      ├─ assets/
      │   └─ bridge/inject.js           # DashboardFunction.ajaxCall hook (§4)
      ├─ java/com/restro/waiter/
      │  ├─ App.kt                      # Application: DB, cookie init, crash log capture
      │  ├─ ui/
      │  │  ├─ SplashActivity.kt        # auto-connect last server (§S1)
      │  │  ├─ ServerSetupActivity.kt   # scan + manual URL + saved profiles + QR (§S2)
      │  │  ├─ LoginActivity.kt         # posts to ROLoginWebService.asmx (§S3)
      │  │  ├─ MainActivity.kt          # TAB_HOST: WebView tabs (Dining / Orders-lite / Prints / Diag)
      │  │  ├─ PrintsActivity.kt        # print job history + retry
      │  │  └─ DiagnosticsActivity.kt   # connectivity, printer ping, log export
      │  ├─ web/
      │  │  ├─ WaiterWebView.kt         # config, cookie sync, keep-alive
      │  │  ├─ Bridge.kt                # @JavascriptInterface API (§3)
      │  │  └─ UrlBuilder.kt            # {server}/Default.aspx?id={pageId} (+token params)
      │  ├─ net/
      │  │  ├─ ServerScanner.kt         # parallel subnet probe + validation
      │  │  ├─ LoginApi.kt              # ROLoginWebService.asmx/Login, LoginPin
      │  │  └─ HealthCheck.kt           # GET / + HEAD .asmx, version.json
      │  ├─ print/
      │  │  ├─ PrinterManager.kt        # registry of printers, default routing
      │  │  ├─ TcpEscPosPrinter.kt      # socket 9100 write + status read
      │  │  ├─ EscPosBuilder.kt         # bytes from base64 payload (server or local)
      │  │  └─ PrintQueueWorker.kt      # Room-backed retry queue (max 3, exponential)
      │  ├─ data/
      │  │  ├─ AppDatabase.kt           # Room: servers, printers, print_jobs, logs
      │  │  ├─ Prefs.kt                 # EncryptedSharedPreferences (Keystore)
      │  │  └─ entities.kt
      │  └─ diag/
      │     ├─ CrashReporter.kt         # Thread.setDefaultUncaughtExceptionHandler → logs table
      │     └─ LogExporter.kt           # share-as-text file
      └─ res/xml/network_security_config.xml
```

`app/build.gradle.kts` dependencies (all free/OSS):
```kotlin
implementation("androidx.appcompat:appcompat:1.7.0")
implementation("androidx.webkit:webkit:1.11.0")
implementation("androidx.room:room-runtime:2.6.1"); kapt("androidx.room:room-compiler:2.6.1")
implementation("androidx.security:security-crypto:1.1.0-alpha06")
implementation("com.squareup.okhttp3:okhttp:4.12.0")
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1")
implementation("com.google.zxing:core:3.5.3")            // QR provisioning
implementation("com.github.DantSu:ESCPOS-ThermalPrinter-Android:3.3.0") // optional; Phase 1 uses raw sockets
```

---

## 2. Bridge API contract (`window.WaiterBridge.*`)

Injected as `addJavascriptInterface(Bridge(webView, app), "WaiterBridge")`. Every method returns void; results come back via callbacks registered in JS.

```kotlin
class Bridge(...) {
  @JavascriptInterface fun ready()                                   // inject.js handshake
  @JavascriptInterface fun getAppVersion(): String                   // e.g. "1.0.4+104"
  @JavascriptInterface fun vibrate(ms: Int)                          // confirm taps / errors
  @JavascriptInterface fun beep(type: String)                        // "sent" | "error" | "warn"
  @JavascriptInterface fun showToast(msg: String)
  @JavascriptInterface fun log(level: String, tag: String, msg: String)   // → Room logs
  @JavascriptInterface fun printRaw(base64: String, dest: String)    // dest="kot"|"bill"|"default"; async
  @JavascriptInterface fun listPrinters(): String                    // JSON array of saved printers
  @JavascriptInterface fun getServerInfo(): String                   // JSON {name,url,pageId,lastLatencyMs}
  @JavascriptInterface fun openExternal(url: String)                 // whitelist http(s) only
  // callback names JS passes in:
  @JavascriptInterface fun onPrintResult(jsCallback: String, jobId: Long, ok: Boolean, err: String?)
}
```

JS side helper (bundled in `inject.js`):
```js
function nativeCall(name, args, cb){
  var c = 'WBCB_' + Math.random().toString(36).slice(2);
  window[c] = function(res){ delete window[c]; cb && cb(JSON.parse(res)); };
  return window.WaiterBridge[name].apply(null, args.concat ? args : []);
}
```

---

## 3. WebView configuration (WaiterWebView.kt) — exact settings

```kotlin
settings.apply {
  javaScriptEnabled = true; domStorageEnabled = true
  allowFileAccess = false; allowContentAccess = false
  mediaPlaybackRequiresUserGesture = false       // beep/notification sounds
  cacheMode = LOAD_DEFAULT                       // CSS/JS cached, JSON never cached by .asmx anyway
}
CookieManager.getInstance().apply {
  setAcceptCookie(true); setAcceptThirdPartyCookies(webView, true) // iframe/print frames
  flush()                                        // after every onPageFinished AND onPause
}
// Auth persistence: ASP.NET_SessionId + SageFrame auth cookie must survive restarts.
// Re-login flow: on redirect to login page (url contains "login"), show native toast +
// auto-post saved credentials via LoginApi, then reload original URL (once; loop-guard flag).
webViewClient = object : WebViewClient() {
  shouldOverrideUrlLoading -> loadUrl() in-app unless host not in saved-server list → openExternal
  onReceivedSslError       -> if error==CERT_AUTHORITY_INVALID && cert chain matches pinned LAN CA → proceed(); else show dialog
  onPageFinished           -> evaluateJavascript(asset inject.js); flush cookies; health-check latency sample
}
WebChromeClient.onPermissionRequest -> grant MEDIA (mic later), deny camera unless scanner enabled
Back button: webView.canGoBack() ? goBack() : double-back-to-exit toast
FLAG_KEEP_SCREEN_ON while Dining tab active; dim after 60s idle only outside dining
```

URL built by `UrlBuilder`: `{savedBaseUrl}/Default.aspx?id={pageId}` where `pageId` comes from the server profile (the Dinning page id required by `Dinning.ascx.cs` QueryString["id"]). Also carry `Notification`/`NumPinPad` behavior unchanged — those are server appSettings, no client work needed.

---

## 4. inject.js — the ONE interception point (safe, verified choke point)

All 48+ calls funnel through `DashboardFunction.ajaxCall` (`DinningJS.js:~320-360`). We wrap it — do NOT touch jQuery global:

```js
(function(){
  if (!window.WaiterBridge || window.__rwHooked) return;
  window.__rwHooked = true;
  var orig = DashboardFunction.ajaxCall.bind(DashboardFunction);
  DashboardFunction.ajaxCall = function(cfg){
    var m = cfg.method || '';
    // Phase 1: observability only (no re-routing yet)
    try {
      WaiterBridge.log('api', m, JSON.stringify({url:cfg.url, mode:cfg.ajaxCallMode}));
      if (m === 'savePrintCount') WaiterBridge.log('print', 'count', cfg.data||'');
      if (m === 'SaveSalesBill')  WaiterBridge.vibrate(60);   // tactile "order sent"
    } catch(e){}
    return orig(cfg);
  };
})();
```

Phase 2 will extend this same wrapper with: failure capture → Room queue (needs §7.1 idempotency first) and a `checkOrder` heartbeat timer. Nothing else in DinningJS.js is patched → zero regression surface for ordering logic.

---

## 5. Server discovery & profiles (ServerScanner.kt + S2 UI)

### 5.1 Scan algorithm
```
Input: CIDR (default: derive from Wi-Fi DHCP: x.y.z.0/24) or hostname/IP typed manually.
For each candidate (≤254 hosts, coroutines, Semaphore(64), timeout 1200ms):
  1. TCP connect 80, 443, 8080, 8443          → keep hosts with any open port
  2. GET http{s}://{ip}/                       → follow redirect, require HTTP 200
  3. Validation regex over HTML:               /Modules\/Dinning/i OR /DashBoardWebService/i
                                               OR title contains configured restaurant name
  4. Record latency, detected scheme/port.
Output list sorted by latency; user picks → Save Profile.
```
Never mark a host "found" without step 3 — avoids picking up printers/CCTV/NAS boxes that also answer on 80/8080.

### 5.2 Profile entity (Room `servers`)
```
id PK, name, baseUrl(text, no trailing /), pageId(int), tlsPinned(bool),
lastUsed(long), lastLatencyMs(int), isDefault(bool), createdAt
```
Encrypted at rest via EncryptedSharedPreferences only for credentials; URLs stay plain in Room (non-secret).

### 5.3 QR provisioning format (generate from admin/back-office page later; parse now)
```
restrowaiter://config?name=Rajwaani&url=https%3A%2F%2F192.168.1.50%3A8443&id=42&user=waiter1&pin=1234
```
ZXing scanner → validate scheme → prefill ServerSetup → confirm → save. Fallback: same string pasted manually.

### 5.4 TLS on LAN
- Ship `network_security_config.xml` with `<debug-overrides>` + a **user-installed CA trust**: accept system-added LAN CA (OpenSSL one-liner doc in README: mkcert for `waiter.lan`).
- `onReceivedSslError`: auto-proceed ONLY when (a) profile has `tlsPinned=true` and (b) SHA-256 of leaf cert equals stored fingerprint (pinning). Otherwise explicit user consent dialog, remembered per-profile.

### 5.5 IP-change guard
On every `onPageFinished` + app resume: compare current profile's resolved IP vs last seen; if DNS/DHCP moved, run quick reachability sweep across saved alternate URLs and toast "Server moved to 192.168.1.51 — switch?" one-tap.

---

## 6. Printing (native TCP ESC/POS first)

### 6.1 Data flow
```
Option A (preferred): server renders slip bytes.
  Add .asmx WebMethod GetSlipBytes(billNo, type) → reuse PrintRaw/Class1.cs formatting →
  return Convert.ToBase64String(escposBytes). APK just writes bytes to socket.
Option B (zero server change, Phase 1 fallback):
  inject.js detects print trigger (ajaxCallMode for GetDataForPrint/savePrintCount),
  fetches the existing slip HTML, sends it to bridge as base64 HTML;
  EscPosBuilder converts → simple text-mode render (columns=48) covering KOT/bill basics.
```

### 6.2 TcpEscPosPrinter
```
Socket(ip:9100, timeout 3000ms) → write(bytes) → flush → read status bytes (ESC@ DLE EOT queries:
paper-out / cover-open / error) → close. Returns PrintResult{ok, statusFlags}.
```
Retry policy in PrintQueueWorker: attempts ≤3, backoff 2s/6s/15s; each attempt logged to `print_jobs`.

### 6.3 print_jobs entity (feeds Prints tab + reconciliation)
```
id PK, billNo(text SMID), dest(kot|bill), printerId, state(PENDING|PRINTED|FAILED|RETRYING),
attempts int, lastError, createdAt, updatedAt, serverLogged bool   // confirmed via savePrintCount
```
Prints tab shows the list; FAILED rows have a Retry button. Weekly reconciliation: compare local PRINTED count vs `GetWaiterLog`/`savePrintCount` records → surfaces slips printed but not billed (real-life dispute solver).

---

## 7. Minimal server patches (each < 1 day, additive, no regressions)

### 7.1 Idempotent SaveSalesBill (prerequisite for ANY future offline replay — Phase 2 gate)
In `DashBoardWebService.asmx.cs` `SaveSalesBill`: accept optional `clientGuid` inside `salesMaster`; add column `SalesMaster.ClientGuid nvarchar(50) NULL UNIQUE`; at entry, if a row with same ClientGuid exists → return its SalesMasterId instead of inserting. DinningJS unaffected (field simply absent until Phase 2 sets it).

### 7.2 GetSlipBytes(billNo, slipType) → base64 ESC/POS (uses existing PrintRaw/Class1.cs logic).

### 7.3 version.json at site root: `{"version":"1.0.0","apkUrl":"/app/RestroWaiter-1.0.0.apk","minVersion":"1.0.0","notes":"..."}` → app checks on splash, offers in-app install (FileProvider + ACTION_VIEW intent, user allows "install unknown apps" once).

### 7.4 Optional: second IIS site/virtual app `waiter.<domain>` per DINING_WAITER_APP_OPTIONS.md Option A step 1 (isolated bindings/app pool, longer session timeout).

---

## 8. Diagnostics screen content
- Current profile (URL, pageId, latency sparkline, cert fingerprint match ✔/✘)
- Session check: HEAD `DashBoardWebService.asmx/TestLogin`-style ping → "logged in / expired"
- Printer list with per-printer "Test print" (prints 3-line demo slip + status flags)
- Last 50 log lines (Room `logs`), share-as-file button (LogExporter)
- App version + update check result

---

## 9. Build steps (free toolchain)
1. Android Studio (free) → New Project → Empty Activity (Kotlin) → paste structure above.
2. Gradle sync → drop in files from §1–§6.
3. `Build > Build Bundle(s)/APK(s) > Build APK(s)` → `app-debug.apk` (or generate keystore once for release).
4. Install on tablet: `adb install` or copy APK; enable unknown sources for launcher icon updates.
5. AI-assist option: feed this plan + WAITER_APP_SPEC.md §10 prompt to Google AI Studio Build mode for scaffolding, then hand-verify §3/§4/§6 (those three sections contain the risky details AI builders usually get wrong).

## 10. Acceptance checklist (Phase 1 exit criteria)
- [ ] Fresh tablet, empty app: scan finds server in <20 s on /24, profile saves, survives reboot.
- [ ] Kill app mid-order → reopen → still logged in (cookie persistence), dining page restores.
- [ ] Send order on 3G-slow simulation: UI freezes (existing async:false) but app does NOT ANR/crash; success toast/vibration fires.
- [ ] Unplug Ethernet cable during send → clear error banner, order NOT duplicated after network restore (Phase 1: manual retry only, guided by banner).
- [ ] KOT prints within 2 s of SEND on TCP printer; paper-out shows actionable alert, job lands FAILED with Retry.
- [ ] Print history reconciles with savePrintCount rows (±0 mismatches after 50 slips).
- [ ] Server IP changed (DHCP) → guard toast + one-tap switch works.
- [ ] Self-update: place newer APK + bumped version.json → splash prompts update, installs, data preserved.
- [ ] 360 px phone and 1024 px tablet layouts both usable (touch targets ≥48 px).

## 11. Phase 2 backlog (only after Phase 1 + §7.1)
Offline order queue w/ ClientGuid idempotency · checkOrder heartbeat + READY notifications · native Orders/Bills tabs (GetDataForSalesBill/GetUnpaidBills) · USB/Bluetooth printers · split-bill guest display mode · loyalty lookup screen.
