--- WAITER_APP_SPEC.md (原始)


+++ WAITER_APP_SPEC.md (修改后)
# 🧾 WAITER APP — COMPLETE BUILD SPEC (Copy-Paste into a Free AI Builder)

**Project:** "RestroWaiter" — Android APK that hosts the existing SageFrame/RestroOrder Dining module in a WebView, plus native features the web page cannot do (server scanning, saved servers, offline order queue, real ESC/POS printing, print-status tracking, bill viewing).

**How to use this file:** Open https://aistudio.google.com (Gemini 2.5 Pro, **free**) → paste Section 10 prompt → it generates a complete Android Studio project you can build with one click. Alternatives in Section 1.

---

## 1. RECOMMENDED FREE AI BUILDERS (ranked for THIS task)

| Rank | Tool | URL | Free tier | Why for this job |
|---|---|---|---|---|
| ⭐ 1 | **Google AI Studio – Build mode** | aistudio.google.com/apps/builder | ✅ Free, unlimited-ish (rate-limited Gemini 2.5 Flash; Pro quota daily) | Generates a FULL multi-file Android/Kotlin app + **live APK preview & download**. Best at WebView + OkHttp + Room code. No credit card. |
| 2 | **Claude.ai (free)** | claude.ai/new | ✅ Free chat | Best single-response code quality; paste this spec, ask for files one-by-one; you assemble in Android Studio. Cannot output an APK directly. |
| 3 | **Cursor IDE (free tier)** | cursor.com | ✅ 2 weeks Pro trial, then free limited | Agent mode writes the whole project into your folder and runs Gradle for you. |
| 4 | **GitHub Copilot Free** | github.com/features/copilot | ✅ Free tier (2000 completions/mo) | Good for filling in files after scaffolding. |
| 5 | **Bolt.new / Lovable** | bolt.new | ⚠️ Limited free credits | Web-first; NOT good for native Android APK. Skip for this task. |

**Verdict:** Use **Google AI Studio (Build mode)** — it is the only free tool that produces a *downloadable, installable APK* from one prompt. Fallback: Claude free → copy files → Android Studio (free) → Build > Build APK(s).

---

## 2. WHAT THE EXISTING PROJECT ALREADY GIVES US (verified in repo)

- `SageFrame/Modules/Dinning/Dinning.ascx(.cs)` + `DinningJS.js` (~156 KB) — full table-layout/ordering UI, already ~95% client-side JS.
- `SageFrame/Modules/RestroDashboard/services/DashBoardWebService.asmx` — **48 JSON `[WebMethod]`s**, called as `…/services/DashBoardWebService.asmx/<Method>` (see `DinningJS.js:74 baseURL`). Key methods the app reuses:
  - Tables/menu: `getLayoutTable, gettabledataByIdforMenu, GetTableByRoomTypeId, getTable, getroomdataByIdforMenu, shiftTable, MergeTables, UnMergeTable, GetMergedTables, ClearMergeList, checkOrder`
  - Orders/bills: `SaveSalesBill, GetDataForSalesBill, GetDataForTakeAwaySalesBill, GetUnpaidBills, SaveSplittedData, UpdateSalesPayMode, CancelOrderIntoDataBase, GetComplimentaryOrders, GetDataForPrint, savePrintCount`
  - Payments/misc: `CheckPin, OpenDrawer, callWaiter, SaveCus, getMemberDetailsbyinfo, CheckLoyaltyForDiscount, SaveTotalCashPaid, GetWaiterLog, gettabledataforshift`
- Login service: `SageFrame/Modules/ROUSER/ROLoginWebService.asmx` → `Login`, `LoginPin`, `CheckLogin`, `LoggedOut`, `TestLogin`, `getWaiterList`. (PIN pad data: `ROUSER/PinLoginUser.Json`; dining page requires `QueryString["id"]` = the Dinning page id.)
- Printing today: `DinningJS.js:2764 print()` → hidden iframe `window.frames["frame1"].print()` (browser print dialog — **unusable on tablets**), and `savePrintCount` (line 809-814) logs `{Printcount, BillNo(SMID), PrintedBy}`. Server-side helpers exist: `PrintRaw/Class1.cs` (raw ESC/POS) and `HTMLtoPDF/GeneratePDF.cs`.
- Order status: only manual `checkOrder` — **no polling exists** → the app adds a status watcher (Section 4, screen S6).

---

## 3. APP ARCHITECTURE

```
┌────────────────────────── RESTROWAITER APK ──────────────────────────┐
│  Kotlin, minSdk 24 (Android 7+), targetSdk 34                        │
│                                                                      │
│  [S1 Splash/AutoConnect] → [S2 Server Setup] → [S3 Login]            │
│        │                       scan LAN,          user/pass or PIN    │
│        │                       save server                            │
│        ▼                                                              │
│  [S4 TAB BAR]                                                         │
│   ├─ Tab DINING : WebView → {server}/Default.aspx?id={pageId}        │
│   │      JS bridge: window.WaiterApp.*  (print, toast, vibrate,      │
│   │      offline-capture, share, back)                                │
│   ├─ Tab ORDERS : native list of sent orders + live status chips     │
│   ├─ Tab BILLS  : open/unpaid bills, view, reprint KOT, split-check  │
│   ├─ Tab PRINTS : every slip's print status (OK / FAILED / PENDING)  │
│   └─ Tab MORE   : settings, printers, theme, logout, diagnostics     │
│                                                                      │
│  Native services:                                                    │
│   • NetworkHelper (OkHttp): ping server, detect IP change            │
│   • LanScanner: /24 sweep + mDNS (_http._tcp) + known-host retry     │
│   • EscPosPrinter: TCP:9100 / USB / Bluetooth (DantSu ESC-POS-Printer)│
│   • PrintQueue (WorkManager): retry ×3, fallback to PDF preview      │
│   • OfflineOrderStore (Room): queued orders, sync when online         │
│   • StatusPoller (WorkManager, 20 s): checkOrder diff → notify+sound │
│   • CookieJar shared with WebView (ASP.NET_SessionId persists)       │
└──────────────────────────────────────────────────────────────────────┘
             │ HTTPS/HTTP (LAN or domain)
             ▼
   IIS site (existing RestroOrder) — NO server code changes required
```

**Design rule:** everything that works inside the WebView stays on the web page (orders, menu, billing logic — already built). The APK only adds what a browser on a tablet *cannot* do: find the server, remember it, print to raw ESC/POS, keep working when Wi-Fi drops, and push order-status alerts.

---

## 4. COMPLETE FEATURE LIST (each solves a REAL waiter problem)

### S2 — Server Scan / Connect / Save  *(Problem: "IP changed / new router / staff doesn't know URLs")*
- **F2.1 Auto-scan**: enter subnet prefix once (e.g. `192.168.1.`) → app sweeps `.1–.254` ports 80/443/8080 in parallel (OkHttp, 300 ms timeout, progress bar). Also broadcasts mDNS `_http._tcp._local` for machines publishing the site.
- **F2.2 Smart candidates**: remembers last-good IPs first (gateway, previously used), so scans finish <5 s usually.
- **F2.3 Validate hit**: GET `/` and `/Default.aspx?id=<pageId>`; must return HTML containing `Dinning` markers → shows hostname + app version found.
- **F2.4 Saved servers list**: name + URL + auto-detected badge; star one as default; long-press → edit/delete/re-test. Stored in SharedPreferences (encrypted via EncryptedSharedPreferences).
- **F2.5 One-tap connect**: launch screen shows saved servers; tap → connects. If default fails, auto-scans again and suggests replacements.
- **F2.6 QR import**: admin prints QR containing `restrowaiter://connect?server=http://192.168.1.50&id=42` → camera scan (MLKit) configures the tab instantly. Deep link intent filter `restrowaiter://`.
- **F2.7 Manual IP/host/port entry** always available + history autocomplete.
- **F2.8 IP-change guard**: before each WebView load, HEAD request to cached base; if unreachable but LAN scan finds the same app on a new IP → toast "Server moved to 192.168.1.77 — switch?" one-tap update. *(Real-life: router reboot gave the server a new DHCP address mid-shift; waiters currently can't log in at all.)*

### S3 — Login  *(Problem: shared tablets, long typing, session dies mid-shift)*
- **F3.1** Two modes: username/password OR **PIN** (posts to `ROLoginWebService.asmx/LoginPin` — already exists in repo).
- **F3.2** Remember-me per device (cookie jar persisted); auto re-login via saved credentials when `ASP.NET_SessionId` expires → **waiter never sees a login wall mid-order**.
- **F3.3** Session-expiry watchdog inside WebView: injects JS that watches for redirect to login page → triggers silent native re-login and restores previous tab/table state (reload + auto-open last table number).
- **F3.4** Per-waiter profile: name shown in header, `GetWaiterLog`/shift binding via `gettabledataforshift`.
- **F3.5** Logout clears only app cookies, not other apps.

### S4 — Dining WebView Tab  *(Problem: tiny touch targets, accidental zoom, refresh loses cart)*
- **F4.1** Full-screen WebView, JS enabled, DOM storage, wide viewport (`useWideViewPort`, loadsWithOverviewMode), zoom controls OFF (prevents stuck pinch-zoom — classic tablet complaint).
- **F4.2** Injected CSS/JS pack: enlarges buttons ≥48 px, hides admin chrome/sidebar, sticky footer with current table no. + running total.
- **F4.3** Pull-to-refresh wrapper; back button = `webView.goBack()` with confirm-if-form-dirty.
- **F4.4** Pre-loader with spinner + timeout(15 s) + friendly error screen with Retry/Scan buttons (never a white page).
- **F4.5** Keep-screen-on while tab active.

### S5 — Send Order + Offline Queue  *(Problem: order lost when Wi-Fi drops at peak hours; double-send when tapping twice)*
- **F5.1 Bridge hook `WaiterApp.captureOrder(json)`**: injected JS intercepts the AJAX right before `SaveSalesBill`/order-send fires; payload logged locally.
- **F5.2 Offline detection**: `NetworkCallback` + heartbeat to server. If offline at send-time → order stored in Room DB as `QUEUED`, big yellow banner "OFFLINE MODE", waiter keeps taking orders on paper-style list.
- **F5.3 Auto-sync**: on reconnect, WorkManager replays queued orders through the same `.asmx` endpoints; success → green toast "Order #12 synced"; conflict (table already billed by another waiter) → red alert with both versions.
- **F5.4 Double-tap lock**: send button disabled 3 s + local dedupe hash of cart contents → prevents duplicate KOTs (top real-world incident).
- **F5.5 Draft autosave**: cart snapshot every 15 s into Room; crash/kill → restore dialog "Continue draft for Table 7?".
- **F5.6 Sent-order receipt chip**: after successful send, show "KOT sent ✓ 12:41:03" with items count.

### S6 — View Sent Orders + Live Status  *(Problem: waiter walks to kitchen to ask "is it ready?", annoys chefs, abandons tables)*
- **F6.1 Orders tab**: list = date/time, table, items summary, amount, status chip. Data from `GetDataForSalesBill` + `checkOrder` (existing methods). Filters: My tables / All open / Closed / Cancelled.
- **F6.2 Status engine**: `StatusPoller` calls `checkOrder` every 20 s (configurable 10–60 s), diffs against last snapshot → statuses: `SENT → PREPARING → READY → SERVED / CANCELLED`.
- **F6.3 Push-like alerts**: when any item flips to READY → heads-up notification + sound + vibration + red dot on table number in Dining tab. *(Uses foreground poller; no Firebase needed.)*
- **F6.4 Mark served**: one tap posts status update (reuses existing update path; if none exists, add 1 tiny WebMethod `UpdateOrderItemStatus` — flagged in §7 optional server patch).
- **F6.5 Order detail sheet**: per-item status, time since sent ("Curry — 14 min ⏱"), course grouping (starter/main/dessert), notes.
- **F6.6 Late-warning**: configurable threshold (default 15 min) → amber highlight + "Send reminder to kitchen" button which fires `callWaiter`/kitchen-alert pattern already present in repo.

### S7 — Bills  *(Problem: guest asks "what's my total?", waiter must walk to cashier; wrong amounts argued)*
- **F7.1 Bills tab**: `GetUnpaidBills` → open bills with table, guests, subtotal/tax/discount/service charge, payment mode, age (mins). Tap → full bill view rendered from `GetDataForSalesBill` (read-only HTML preview, same layout as printed copy).
- **F7.2 Show-to-guest mode**: fullscreen bill, large font, "Present" button — guest verifies on the tablet (kills disputes).
- **F7.3 Split bill**: button opens existing `SaveSplittedData` flow (already implemented in web module; app just hosts it natively-accessible).
- **F7.4 Quick totals widget**: floating chip on Dining tab showing running total of current table (from captured responses, no extra server calls).
- **F7.5 Loyalty/member lookup**: `getMemberDetailsbyinfo` + `CheckLoyaltyForDiscount` exposed as a "Guest?" mini-sheet from the bill screen.
- **F7.6 Cash drawer**: "Open Drawer" button → `OpenDrawer` WebMethod + native ESC/POS kick drawer pulse on connected printer.

### S8 — Printing (the core native win)  *(Problem: browser print dialog on tablets = nothing prints, or prints to wrong station)*
- **F8.1 Printer registry**: add printers with type **TCP (IP:9100)**, **USB**, **Bluetooth Classic**; test-page button; store per role: Kitchen-1, Kitchen-2, Bar, Bill/Cashier, Courier. *(Real-life: one tab must reach 3 stations; browsers can't.)*
- **F8.2 Bridge `WaiterApp.print(base64Html, role)`**: injected JS overrides `DashboardFunction.print()` → instead of `iframe.print()`, sends slip HTML to native side.
- **F8.3 Renderer**: HTML→ESC/POS conversion (native lib `escpos-coffee`/custom converter: 58/80 mm width, bold, cut, logo) using the SAME slip markup the web page already generates via `GetDataForPrint` — zero template rewrite.
- **F8.4 PrintQueue via WorkManager**: each job = slip + copies + role. Retry policy 3× exponential backoff. Result recorded per attempt.
- **F8.5 Fallback**: if no printer reachable → generate PDF preview + Android system print (still gets paper out) + banner "Printer offline".
- **F8.6 Call `savePrintCount`** on success so DB print counts stay truthful (matches existing fields `{Printcount, BillNo, PrintedBy}`).
- **F8.7 Reprint anytime** from Bills/Orders screens (guest claims "KOT lost" — 2 taps).

### S9 — Print Status Tracking  *(Problem: waiter assumes KOT printed, food never arrives, blame war)*
- **F9.1 Prints tab**: every slip = `SLIP# / table / role / station / time / status` where status ∈ `PENDING, PRINTED ✓, RETRYING ⟳, FAILED ✗ (reason: TIMEOUT / NO RESPONSE / PAPER OUT / OFFLINE)`.
- **F9.2 ESC/POS read-back**: for TCP printers query status bytes (DCTEK/Epson status protocol: paper-end, cover-open, error) → real hardware state, not guesswork.
- **F9.3 Failure alert**: FAILED → persistent notification + toast + badge on Prints tab; one-tap Retry or Print-via-system-PDF.
- **F9.4 Audit trail**: failed attempts also written via `savePrintCount` variant/log so manager sees why kitchen missed orders.
- **F9.5 Station health strip**: colored dots per printer (green/red) in More tab; tap → test print.

### S10 — Everyday Tablet/Phone Realities  *(Problems observed in restaurants daily)*
- **F10.1 Any resolution**: layouts use ConstraintLayout + `sw600dp` two-pane (list+detail) for tabs, single column for phones; tested 360 px → 1280 px; landscape supported both ways.
- **F10.2 Dark mode + high-brightness day mode** (sunlit terrace readability).
- **F10.3 Battery**: foreground poller uses WorkManager batching (not tight loops); optional "power saver" extends poll to 60 s.
- **F10.4 Multi-user kiosk feel**: quick-switch waiter (PIN only, 4 digits) without full logout.
- **F10.5 Crash safety net**: WebView renderer-crash listener reloads page preserving tab + table via saved state.
- **F10.6 Diagnostics screen**: ping server, HTTP latency graph, printer reachability, app logs export/share (WhatsApp/email) — ends "it doesn't work, fix it" phone calls to IT.
- **F10.7 Self-update**: on launch check `/version.json` (hosted next to site); newer → download APK prompt (no Play Store needed for internal devices).
- **F10.8 Permissions handled gracefully**: INTERNET, NETWORK_SCAN/CHANGE_WIFI_STATE, BLUETOOTH(_CONNECT), POST_NOTIFICATIONS (Android 13+), CAMERA (QR).

---

## 5. DATA / STORAGE MAP (client side)

| Store | Contents |
|---|---|
| EncryptedSharedPreferences | server list, default server, creds (optional), page id, printer configs, poll interval |
| Room `offline_orders` | id, tableId, cartJson, createdAt, syncState(QUEUED/SYNCED/CONFLICT), error |
| Room `order_snapshots` | orderId, statusJson, lastPolledAt → drives status diff + alerts |
| Room `print_jobs` | slipType, role, payloadHash, attempts, lastError, smid, printedBy |
| SharedPrefs cache | lastBaseURL, lastGoodIpTime, appVersionShown |

All server truth stays in the existing SQL DB; app stores only caches/queues.

---

## 6. KEY SCREEN FLOWS

```
Launch → saved server reachable? ─yes→ PIN login (auto) → Tab:Dining
              │no                                       ↖ bridge hooks: captureOrder/print
              ▼
        Scan screen (progress) → pick server → save → continue
Tab:Orders ← poller flips READY → notification → tap → mark served
Tab:Bills  → select table → present to guest → split / pay / reprint KOT
Tab:Prints → FAILED row → Retry → OK ✓ (logged)
```

---

## 7. OPTIONAL SERVER-SIDE PATCHES (small, keep them minimal)

1. `GET /version.json` static file `{ "version":"1.0.3","url":"/apk/restrowaiter.apk" }` → powers F10.7 self-update.
2. One WebMethod `GetOrderItemsStatus(tableId)` returning per-item status rows if `checkOrder` lacks item granularity (verify first — may already suffice).
3. In `DinningJS.js` add 3 lines guarded by `if(window.WaiterApp)`: route `DashboardFunction.print()` → `WaiterApp.print(html,'bill'|'kot')`, and post cart JSON to `WaiterApp.captureOrder(...)` on send. Everything else unchanged.
4. IIS: second site/virtual-app `waiter.yourdomain` → same folder/app pool; enable Basic-less cookie auth; ensure TLS cert valid for hostname (root web.config has HSTS includeSubDomains — self-signed breaks WebView).

---

## 8. BUILD STEPS AFTER AI GENERATES CODE

1. Install Android Studio (free) → New Project from the generated sources (or AI Studio "Download").
2. `gradlew assembleDebug` → `app-debug.apk`; sign release later (`keytool` + `assembleRelease`).
3. Sideload to tablets (`adb install` or Files-by-URL from IIS `/apk/`).
4. Test matrix: phone 360×640, 10" tablet 1280×800, Wi-Fi off mid-order, printer unplugged, server IP changed, session expired during ordering.

---

## 9. ACCEPTANCE CHECKLIST (all must pass)

- [ ] Fresh tab: scan finds IIS server in <30 s on /24; saved; survives reboot; survives IP change (one-tap migrate)
- [ ] QR provisioning sets server+page id in <10 s
- [ ] PIN login works; session expiry invisible to waiter (auto re-login + table restored)
- [ ] Order placed online → appears in Orders tab ≤20 s with correct status transitions
- [ ] Airplane-mode order → QUEUED banner → auto-sync on reconnect, no duplicates (double-tap test)
- [ ] READY item → notification+sound <5 s after kitchen flip
- [ ] Bill present-to-guest matches printed total exactly
- [ ] Split bill round-trips existing `SaveSplittedData`
- [ ] KOT prints on TCP:9100 thermal; paper-out detected → FAILED with reason; retry succeeds; `savePrintCount` incremented
- [ ] Printer down → PDF fallback prints via system dialog
- [ ] Runs on Android 7+ phones and 10" tablets, portrait+landscape, dark/light

---

## 10. ⬇️ MASTER PROMPT — PASTE INTO Google AI Studio (Build) or Claude

```
You are a senior Android engineer. Build a complete production-quality Android app
"RestroWaiter" in Kotlin (Jetpack, minSdk 24, targetSdk 34, Material 3) that wraps an
existing ASP.NET restaurant system's Dining module and adds native waiter features.

SERVER (already exists, do not redesign; call these exact endpoints):
- Base URL entered/scanned by user, e.g. http://192.168.1.50 or https://waiter.example.com
- Dining page: {base}/Default.aspx?id={pageId}   (pageId setting, default 42)
- Auth service: {base}/Modules/ROUSER/ROLoginWebService.asmx/{Login|LoginPin|CheckLogin|LoggedOut}
  (POST, contentType application/json, body {"username":"..","password":".."} or {"pin":"...."})
- Data service: {base}/Modules/RestroDashboard/services/DashBoardWebService.asmx/{method}
  Methods used: getLayoutTable, checkOrder, GetDataForSalesBill, GetUnpaidBills,
  savePrintCount({Printcount,BillNo,PrintedBy}), OpenDrawer, callWaiter,
  getMemberDetailsbyinfo, CheckLoyaltyForDiscount, SaveSplittedData
- Responses are JSON wrapped like {"d":...}. Cookies: ASP.NET_SessionId must persist
  (use a persistent OkHttp JavaNetCookieJar shared with the WebView CookieManager).

SCREENS / FEATURES TO IMPLEMENT (all of them):
1. Splash + auto-connect: if a saved server responds within 3s go straight to login/tab
   screen; else show server setup.
2. Server setup: (a) manual host/IP/port/https entry with history autocomplete;
   (b) LAN scanner: input subnet prefix e.g. "192.168.1." → parallel probe ports
   80,443,8080 across .1-.254 with 300ms timeout, live progress list, validate the
   responder by fetching /Default.aspx?id={pageId} and checking HTML contains "Dinning";
   (c) mDNS browse _http._tcp.local; (d) saved-servers list (name/url/starred default,
   long-press edit/delete/test); (e) QR scan (MLKit) of restrowaiter://connect?server=..&id=..
   deep link; (f) IP-change guard: before WebView load, HEAD cached base; on fail run
   fast rescan of known IPs and offer one-tap switch. Store servers in
   EncryptedSharedPreferences.
3. Login: username/password OR 4-digit PIN via ROLoginWebService; remember-me with
   silent re-login when session dies (WebView redirects to login page → detect URL,
   re-auth natively, restore previous tab and last table via saved state).
4. Main Activity with bottom nav, 5 tabs:
   A) DINING: full-screen WebView of {base}/Default.aspx?id={pageId}; JS enabled, DOM
      storage, no zoom controls, injected CSS raising touch targets to >=48px and hiding
      sidebar; pull-to-refresh; back=goBack; keep screen on; crash-listener reload;
      JS interface object "WaiterApp" exposing:
        print(html:String, role:String)   // role: kot|bill|bar|courier
        captureOrder(cartJson:String)     // called by injected hook before order send
        toast(msg), vibrate(ms), share(text), openDrawer()
      Injected JS shim (evaluateJavascript on page finish): override window.DashboardFunction
      print to call WaiterApp.print(html,'bill'); wrap jQuery ajax send for orders to also
      call WaiterApp.captureOrder(JSON.stringify(args)).
   B) ORDERS: native list from checkOrder/GetDataForSalesBill: time, table, items count,
      amount, status chip SENT/PREPARING/READY/SERVED/CANCELLED; filters mine/open/closed;
      detail bottom sheet with per-item elapsed minutes; "mark served"; "remind kitchen"
      (>15min, calls callWaiter). Background StatusPoller (WorkManager PeriodicWorker,
      20s configurable) diffs snapshots in Room table order_snapshots; READY -> heads-up
      notification + sound + vibration + badge.
   C) BILLS: GetUnpaidBills list (table, age mins, totals, payment mode); tap -> full bill
      HTML preview (GetDataForSalesBill) in dialog; "Present to guest" fullscreen mode;
      split button opens SaveSplittedData web page section; loyalty lookup sheet
      (getMemberDetailsbyinfo+CheckLoyaltyForDiscount); open cash drawer.
   D) PRINTS: print job log: slip#, table, role/station, time, status
      PENDING/PRINTED/RETRYING/FAILED(reason TIMEOUT|PAPER_OUT|COVER_OPEN|OFFLINE);
      retry button; reprint from here; audit rows also posted via savePrintCount on success.
   E) MORE: printer manager (add/edit/test/remove printers: TCP ip:9100, USB, Bluetooth
      Classic; map to roles KITCHEN1/KITCHEN2/BAR/BILL); poll interval; theme light/dark/
      auto; waiter quick-switch (PIN); diagnostics (ping+latency chart, printer reachability,
      export/share logcat); check app update from {base}/version.json; logout.
5. Offline order queue: register NetworkCallback + 15s heartbeat to base URL. When send
   happens offline (captureOrder hook detects no connectivity OR ajax fails), store Room
   entity offline_orders(id, tableRef, cartJson, createdAt, syncState QUEUED/SYNCED/CONFLICT,
   errorMsg) and show persistent yellow banner "OFFLINE MODE - N orders queued". On regain,
   SyncWorker replays through DashBoardWebService in FIFO order; conflicts (same table billed
   meanwhile) -> red alert dialog. Double-send protection: disable send 3s + dedupe hash of
   cartJson within 10s window. Cart draft autosave every 15s; restore dialog on cold start.
6. ESC/POS printing engine: library com.github.DantSu:ESCPOS-ThermalPrinter-Android:3.3.0.
   Convert slip HTML to formatted text (strip tags, preserve lines/columns, price alignment,
   bold headers, 42/32 char width for 80/58mm, feed+cut). Job queue via WorkManager, 3 retries
   exponential backoff, results recorded to print_jobs Room table feeding tab D. For TCP
   printers query status bytes (Epson/DCTEK status request) to detect paper-out/cover-open.
   If all printers of a role fail -> render PDF preview + fire Android system PrintManager
   job as fallback and mark FAILED-with-fallback.
7. Cross-cutting: single source of truth ApiClient(OkHttp) building .asmx JSON POSTs;
   CookieSyncManager flush after WebView auth; all network on coroutines/Retrofit;
   responsive: ConstraintLayout, values-sw600dp two-pane master-detail for Orders/Bills,
   phone single-column; support landscape+portrait; Material 3 dynamic color, dark theme;
   notifications channel "orders" high importance; runtime permissions flow
   (INTERNET, ACCESS_NETWORK_STATE, CHANGE_WIFI_STATE, NEARBY_WIFI/BLUETOOTH_CONNECT,
   POST_NOTIFICATIONS API33+, CAMERA for QR); Room schema versioned; ViewBinding; MVVM
   with Hilt; ProGuard rules; app icon placeholder; versionName from gradle.
8. Provide: full file tree, every Kotlin/XML/Gradle file complete (settings.gradle,
   build.gradle root+app with dependencies okhttp, retrofit+converter-gson? use plain
   okhttp+gson if simpler, room-runtime/ktx/compiler, work-runtime-ktx, hilt,
   material, escpos printer lib, mlkit-barcode, androidx security-crypto), AndroidManifest
   with deep-link intent filter restrowaiter, internet perms, activities, workers;
   the injected JS shim as asset file bridge_shim.js; README with build instructions.
   Code must compile as-is; stub anything impossible with TODO comments listing assumption.
```

**Follow-up prompts to refine (ask one at a time):** “now write the LanScanner class fully with coroutine Flow progress” · “implement HtmlToEscPos converter handling <table> slips” · “write the injected bridge_shim.js that hooks DashboardFunction.print and order ajax”.

---

## 11. RISK NOTES (tell the AI / verify manually)

- WebView on Android 7+ needs `WebViewAssetLoader` only if mixing file/http; we don’t — pure remote URL.
- `allowMixedContent` required if IIS still serves HTTP on LAN (set true, document risk; plan TLS via `HTTPS_MIGRATION_GUIDE.md` in repo).
- Root `web.config` sends `X-Frame-Options: DENY` — irrelevant for WebView top-level loads, fine.
- HSTS preload on subdomains forces HTTPS-only for `*.yourdomain` — provision waiter host cert properly or keep LAN-IP mode.
- `.asmx` GET test pages exist but app must POST JSON exactly like `DinningJS.js` does (`contentType:'application/json', data:JSON.stringify(...)`), else ASMX rejects payload shape.
- Verify `checkOrder` returns per-item granularity before promising READY alerts; otherwise add the one WebMethod from §7.2.
