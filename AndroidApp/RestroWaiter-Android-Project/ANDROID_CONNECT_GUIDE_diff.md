--- ANDROID_CONNECT_GUIDE.md (原始)


+++ ANDROID_CONNECT_GUIDE.md (修改后)
# How the New Android (Waiter) App Connects to Our Existing Project

**TL;DR: The APK does NOT connect to the project's code files. It connects over HTTP(S) to the IIS site that is already serving this exact project — the same URL your waiters open in Chrome today.** Nothing in the ASP.NET project is rewritten; the app just points at it and adds a tiny 1-file server patch for printing + discovery.

---

## 1. The connection model (verified against this repo)

Your dining screen is rendered by SageFrame as a normal web page:

```
https://<server>/Default.aspx?id=<DinningPageId>
        └── loads Dinning.ascx → injects DashboardFunction.config:
              ModulePath = ResolveUrl(AppRelativeTemplateSourceDirectory)   // Dinning.ascx.cs:32
              baseURL    = ModulePath + "services/DashBoardWebService.asmx/" // DinningJS.js:74
```

Every waiter action (open table, send order, bill, split…) is a JSON POST from that page to `DashBoardWebService.asmx` (50 WebMethods verified). **The Android app hosts this very page in a WebView.** That is the entire integration. No new API layer, no port changes, no touching business logic.

```
┌─────────────── ANDROID TABLET / PHONE ───────────────┐
│ RestroWaiter.apk                                     │
│  ├─ WebView ──loads──► https://192.168.1.50/         │
│  │                     Default.aspx?id=42            │
│  │      └─ the existing DinningJS.js runs INSIDE it  │
│  │         and calls .asmx exactly like now          │
│  ├─ JS bridge window.NativeBridge ──injected hook──► │  prints
│  └─ OkHttp ──scans/pings LAN servers──────────────►  │
└──────────────────────┬───────────────────────────────┘
                       │ HTTPS (LAN or internet)
┌──────────────────────▼───────────────────────────────┐
│ WINDOWS PC/SERVER RUNNING OUR PROJECT                │
│  IIS → Default Web Site (RestroOrder_Master.sln)     │
│   ├─ Default.aspx (SageFrame portal)                 │
│   ├─ SageFrame/Modules/Dinning/*                     │
│   ├─ .../RestroDashboard/services/                   │
│   │        DashBoardWebService.asmx  (unchanged)     │
│   └─ NEW: App_WebServices/WaiterBridge.asmx (+30 LoC)│
└──────────────────────┬───────────────────────────────┘
                       │ SQL
                 SQL Server (same DB)
```

## 2. One-time server setup (IIS only — 15 minutes)

1. **Publish/run the project in IIS** exactly as you do today (it already works in a browser).
2. **Open the firewall** on the server PC for TCP **80/443** (Inbound rule → Local subnet only, e.g. 192.168.1.0/24). This is the #1 reason tablets "can't find the server".
3. **Find the Dining page ID**: browse the portal as admin to the Dinning page and copy the number after `?id=` (e.g. `Default.aspx?id=42`). Put it in the app settings once.
4. **HTTPS**: either
   - LAN-only: plain `http://192.168.x.x` works (app accepts the cert/no TLS), or
   - proper: free LAN IP not needed — use a real domain with Let's Encrypt, or self-signed + pin the cert in the app (see §5).
5. **Session timeout**: raise IIS session timeout to ~120 min for the waiter site so tablets don't log out mid-shift (web.config `<sessionState timeout="120">`).

## 3. What the app stores to "connect"

On first run the app saves a **server profile** (encrypted, Android Keystore):

| Field | Example | Where it comes from |
|---|---|---|
| Base URL | `https://192.168.1.50` or `https://waiter.mycafe.com` | user types / scan finds it |
| Dining Page ID | `42` | copied from browser address bar (§2.3) |
| Login | username/password **or** waiter PIN | posted to `ROUSER/ROLoginWebService.asmx/Login` / `LoginPin` |
| Printer | IP `192.168.1.90:9100` + name | app's printer setup screen |

Connect string built by the app: `BaseURL + "/Default.aspx?id=" + PageID`. Cookies (`ASP.NET_SessionId`, SageFrame auth) are persisted by `CookieManager` so login survives app restarts.

## 4. Finding the server automatically (the "scan IP" feature)

Two probes, both hitting files that **already exist in this repo** — zero server work:

1. **mDNS** (`_restrowaiter._tcp.local`) if you add one TXT record — optional.
2. **Subnet scan**: for each IP in `192.168.1.0/24`, try `GET http://IP/` in parallel (OkHttp, 300 ms timeout). A hit whose HTML contains `SageFrame` (or `Default.aspx`) = our project. Then confirm with `POST http://IP/SageFrame/Modules/RestroDashboard/services/DashBoardWebService.asmx/TestLogin` → JSON response proves it's a live RestroOrder server. Save as profile.
3. **QR provisioning**: admin opens a page in the back office showing QR = `{url, pageId, pin}`; tablet scans once → connected. (Solves "every waiter typing IPs wrong".)

## 5. Printing — the ONLY server-side change needed

Today `DinningJS.js:2764 print()` uses a hidden iframe → browser print dialog → useless on Android WebView. Fix without touching any other file:

**Server patch (new file, ~30 lines):** `SageFrame/App_WebServices/WaiterBridge.asmx`
```csharp
[WebService(Namespace="http://tempuri.org/")]
[ScriptService]  // enables JSON POST like DashBoardWebService.asmx
public class WaiterBridge : System.Web.Services.WebService {
    [WebMethod] public void RegisterPrinter(string ip, int port, string name) {
        Session["WaiterPrinter_" + User.Identity.Name] = ip + ":" + port + "|" + name; }
    [WebMethod] public string GetMyPrinter() {
        return (string)Session["WaiterPrinter_" + User.Identity.Name] ?? ""; }
}
```

**App patch (injected JS, runs at onPageFinished — wraps the single choke point `DashboardFunction.ajaxCall`, DinningJS.js:~331):**
```javascript
// when method == "savePrintCount" → also tell native layer to print
window.NativeBridge.printBill(data.SalesBillNo);
// when method == "RegisterPrinter"/"GetMyPrinter" → answer from app storage
```
Then the app fetches the slip via existing `GetDataForSalesBill` + `GetDataForPrint` (.asmx, unchanged), formats ESC/POS natively (DantSu library), sends TCP:9100 to the saved printer, logs to Room DB (`print_jobs`), retries on failure, detects paper-out via ESC/POS status read.

**Why this is safe:** injection happens client-side inside the WebView only. Desktop browsers keep using the old iframe print path — nothing breaks for existing users.

## 6. Step-by-step: first successful connection (test checklist)

1. On the server PC: open Chrome → `http://localhost/Default.aspx?id=42` → dining screen OK. ✔ project runs
2. From a second PC on same LAN: `http://<server-ip>/Default.aspx?id=42` → OK. ✔ firewall right
3. Install APK on tablet (same Wi-Fi) → Add Server → Scan → pick found server → enter page id 42 → test connection shows "RestroOrder v… detected". ✔ discovery works
4. Login with a waiter account (must exist under Admin → UserManagement, role mapped in `ROUSER/PinLoginUser.Json` for PIN). ✔ auth works
5. Open a table, send an order → appears in Kitchen same as before. ✔ core flow intact
6. Set printer IP in app → send order → kitchen slip prints within ~2 s, Prints tab shows PRINTED. ✔ native printing
7. Kill Wi-Fi 10 s → banner "offline, queued"; restore → syncs. ✔ resilience

## 7. Common real-life problems & how this design solves them

| Problem waiters hit today | Solved by |
|---|---|
| Tablet browser loses login every hour | persistent CookieManager + session timeout 120 min + silent re-login via ROLoginWebService |
| Router gives server a new IP after reboot | mDNS name + rescan-on-fail banner ("tap to reconnect") |
| Print dialog confusion / wrong printer | native printer registry per waiter (WaiterBridge.asmx), no dialogs |
| Slip lost when printer offline | Room `print_jobs` queue + retry + FAILED badge with manual reprint |
| Two tabs sending same order twice | injected double-send guard around SaveSalesBill + (Phase 2) ClientGuid idempotency |
| Waiter can't tell if kitchen got the order | Orders tab polls existing `checkOrder` every 20 s while foregrounded |
| Guest bill must be shown then paid | fullscreen bill view from `GetDataForSalesBill` + split via `SaveSplittedData` |
| Internet down but LAN alive | everything is LAN-first; app never requires cloud |

## 8. Summary of what changes where

| Component | Change | Effort |
|---|---|---|
| DinningJS.js / .ascx / .asmx services | **none** | 0 |
| IIS site | firewall rule, session timeout, note page-id | 15 min |
| Server code | **+1 file** WaiterBridge.asmx (~30 LoC) | 30 min |
| Android app | new APK (WebView + bridge + scanner + ESC/POS + Room) | generated from WAITER_APP_SPEC.md §10 prompt |

So: **"connecting" = the APK loads `http(s)://<our-IIS-server>/Default.aspx?id=<pageId>`**, keeps its cookies, listens to its AJAX calls through one injected wrapper, and talks to the same database through the same services the web UI already uses.
