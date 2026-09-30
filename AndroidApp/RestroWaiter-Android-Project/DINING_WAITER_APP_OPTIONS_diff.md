--- DINING_WAITER_APP_OPTIONS.md (原始)


+++ DINING_WAITER_APP_OPTIONS.md (修改后)
# Waiter App (Dining Module) — APK vs. Hosted Web App: Options & Recommended Plan

Repo: `RestroOrder_Master.sln` (ASP.NET WebForms / SageFrame). The dining screen is a module
control (`SageFrame/Modules/Dinning/Dinning.ascx` + `DinningJS.js`, ~156 KB of jQuery) that
talks to `Modules/RestroDashboard/services/DashBoardWebService.asmx` (50 `[WebMethod]`s, JSON via
`contentType: application/json`) and shares services with `RoOrderItemProcessing`, `Orders`,
`CallWaiter`, `Billing`, etc.

**Key fact:** the Dinning UI is already 95% client-side JavaScript + JSON web service calls.
That means every option below reuses the existing code instead of rewriting it.

---

## Option A — WebView "wrapper" APK (recommended first step)

Build an Android APK whose only job is to host the existing dining page in a `WebView`.
No rewrite of business logic, no new API layer, works on any resolution because the page
renders inside the app.

```
[APK: MainActivity + WebView]  --HTTPS-->  [IIS site: https://waiter.example.com]
   JS bridge (printing/scanner)                Default.aspx?id=<diningPageId>
                                               DashBoardWebService.asmx (unchanged)
```

What you need to do:

1. **IIS**: create a second site (or virtual application) pointing at the same `SageFrame`
   folder, bound to its own host name/port (e.g. `waiter.yourdomain.com:8443`). Same app pool
   and DB is fine. This isolates waiter traffic from admin users and lets you tune it
   (session timeout, request queue, output caching) without touching the back-office site.
2. **APK shell** (Android Studio, Java/Kotlin, roughly 200 lines):
   - Full-screen `WebView`; `javaScriptEnabled = true`, `domStorageEnabled = true`.
   - Persist cookies: `CookieManager.getInstance().setAcceptCookie(true)` so ASP.NET's
     `ASP.NET_SessionId` + SageFrame auth cookie survive restarts (do NOT clear them).
   - Login handling: `Dinning.ascx.cs` already redirects `anonymoususer` to the portal login
     page — the WebView just follows the redirect. Optionally add a native saved-credentials
     screen that posts to the same login service for one-tap re-login.
   - `shouldOverrideUrlLoading` → always `loadUrl()` inside the app (no external browser).
   - Back button → `webView.goBack()`; keep-screen-on flag; pull-to-refresh wrapper.
3. **Kitchen/receipt printing** (the one thing a WebView can't do natively): add a
   `@JavascriptInterface` bridge, e.g. `Android.printRaw(base64EscPosBytes)` and print over
   TCP/USB/Bluetooth with the `DantSu/ESC-POS-Printer` library. The repo already contains a
   `PrintRaw/` project — reuse its slip formatting server-side and hand bytes to the bridge.
4. **Any-resolution polish**: `<meta viewport>` + media queries for the dining CSS, minimum
   48px touch targets, tested at 360px phone → 1024px+ tablet widths.

Deliverable: signed `.apk` (sideload or Play internal testing). UI updates = deploy to IIS
only; nobody reinstalls the APK unless the bridge changes.

---

## Option B — PWA hosted on IIS ("Add to Home Screen" instead of shipping an APK)

Same IIS site as Option A plus `manifest.webmanifest` and a small service worker. Installable
from Chrome on Android phones/tablets: full-screen, icon on home screen, near-identical UX.

* Pros: zero Android build/signing pipeline, single deployment channel, instant updates.
* Cons: no native printing (pair with Option C), push notifications require HTTPS + FCM/VAPID.
* Files to add under `SageFrame/`: `manifest.webmanifest`, `sw.js` (cache-first for the shell,
  network-first for `*.asmx`), `<link rel="manifest">` + theme-color in the page head.

---

## Option C — Local print agent on the restaurant LAN (pairs with A or B)

Wrap the existing `HTMLtoPDF/` and `PrintRaw/` projects into a tiny Windows service / tray app
on the back-office PC exposing `POST http://192.168.x.x:9100/print` (CORS restricted to the
waiter hostname). The web page posts slip payloads to the LAN agent instead of relying on
browser print dialogs — thermal printers stay reliable, and it works identically inside the
APK WebView and in Chrome/PWA mode.

---

## Option D — Standalone responsive waiter SPA (medium effort, biggest UX win)

Because all data flows through `.asmx` JSON methods, you can lift `DinningJS.js` into a clean
mobile-first app (Vue/React or plain HTML) hosted as a sibling IIS application
(`SageFrame.WaiterApp`) calling the *same* `DashBoardWebService.asmx`:

* Touch-first table map, quantity pad, split/merge bill flows sized for tablets.
* Server-rendered literals in the .ascx (rooms/tables/room types built by `BindRoomsDatas()`,
  `BindRoomType()`) must be exposed as 2–3 extra WebMethods instead of coming from the control.
* Then wrap with Option A or B for the "APK" experience.
* Also fix: `DinningJS.js` uses `async:false` everywhere — convert to async with loading
  states so slow Wi-Fi doesn't freeze the screen.

---

## Option E — Fully native/cross-platform rewrite (highest cost, rarely justified)

MAUI/Xamarin or React Native on top of `SageFrame.RestroOrder` controllers exposed as an API.
Only worth it if you need deep offline order queuing or heavy peripheral integration. Note the
solution is .NET Framework (VS2013-era tooling: `RestroOrder.v12.suo`), so this path first
requires porting `SageFrame.RestroOrder`, `SageFrame.Common`, `SageFrame.Core` to .NET 6/8.

---

## Recommendation

1. **Now:** Option A (WebView APK) + Option C (LAN print agent) — real `.apk`, all current
   features, no logic rewrite, resolution-independent.
2. **In parallel:** Option B manifest so devices can install without sideloading.
3. **Next iteration:** Option D mobile-first rewrite of the dining screens; still served by
   IIS, still wrapped by A/B.

### Gotchas found in this codebase
* Root `web.config` sets `X-Frame-Options: DENY` — irrelevant for a WebView (not an iframe),
  but remove/relax it on the waiter site if you ever embed pages elsewhere.
* HSTS `max-age=63072000; includeSubDomains; preload` at root: the waiter hostname MUST have
  valid TLS or Android WebView refuses to load. Use win-acme/Let's Encrypt or an internal CA
  installed on the devices; self-signed certs are painful on Android.
* SQL connection string uses `Encrypt=True; TrustServerCertificate=False` — needs a proper
  SQL cert, or set `TrustServerCertificate=True` on LAN-only deployments.
* `Dinning.ascx.cs` depends on `Request.QueryString["id"]` (TypeId) and appSettings
  `Notification` and `NumPinPad` — the APK/PWA launch URL must be the real dining page URL
  (`/Default.aspx?id=<pageId>`) and those appSettings must exist on the waiter site.
* Anonymous users get redirected to the portal login page — wrapper must persist cookies and
  ideally offer one-tap re-login.

### Minimal WebView shell sketch (Android, Java)
```java
WebView w = findViewById(R.id.web);
w.getSettings().setJavaScriptEnabled(true);
w.getSettings().setDomStorageEnabled(true);
CookieManager.getInstance().setAcceptCookie(true);
w.addJavascriptInterface(new Object() {
    @JavascriptInterface public void print(String escposBase64) { KitchenPrinter.send(escposBase64); }
}, "Android");
w.setWebViewClient(new WebViewClient() {
    @Override public boolean shouldOverrideUrlLoading(WebView v, WebResourceRequest r) {
        v.loadUrl(r.getUrl().toString()); return true;      // stay in-app
    }
});
w.loadUrl("https://waiter.example.com/Default.aspx?id=DINING_PAGE_ID");
```
