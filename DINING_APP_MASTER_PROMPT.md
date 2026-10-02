# MASTER PROMPT — Build "DiningApp" (All-in-One, IIS-Hostable, On-Prem Replacement of the SageFrame Dining/RestroOrder Module)

> **How to use this document:** Give Claude (or any senior .NET engineer / AI coding agent) THIS ENTIRE FILE as the single implementation prompt. It contains every verified detail extracted from the legacy source code in this repository (`RestroOrder_Master.sln`). Build the app **completely** — backend + frontend + migration engine + deployment artifacts — with no placeholders, no TODOs, no stubs. Every endpoint signature, response envelope, algorithm step, rounding rule, and bug-compatibility note below was read directly from the legacy files; paths are given so you can re-verify at any time.

---

## 0. Mission Statement

Create **one single ASP.NET Core 8 web application** ("all-in-1", no separate API project, no separate SPA host) that:

1. **Replaces the legacy SageFrame dining/waiter module** (the `ROPurchaseOrder` waiter web module + its ASMX services) for an on-premises restaurant ("30 Grill Durbar" style deployments).
2. **Is hosted trivially on IIS** — one publish folder, one site/application, Windows Authentication optional, no SageFrame, no WebForms, no `.asmx`, no enterprise library, no OracleClient, nothing else from the old stack.
3. **Speaks the exact same wire protocol as the existing WEB module's services** (the web module is the newest, authoritative client behavior — the Android APK hits older/different endpoints and is NOT the target). The new app must expose the same URL shapes (`/<Service>.asmx/<Method>`), same parameter names, same request bodies, and byte-compatible response envelopes, so any existing integration keeps working and parity testing is possible by diffing raw responses.
4. **Ships its own responsive waiter-facing SPA** (vanilla HTML/CSS/JS served from `wwwroot`) covering **exactly the existing web features — nothing more, nothing less** — usable on every device class: desktop browser, laptop, tablet, phone (any screen width, touch-first), on Wi-Fi or LAN inside the restaurant.
5. **Includes an AUTO-MIGRATION feature**: on startup the app verifies/creates everything it needs in the SQL Server database (schema baseline check + versioned, additive-only SQL migrations) with zero manual DBA steps.
6. Reuses the **existing database and stored procedures unchanged** (no schema redesign). The app calls the same SPs through `Microsoft.Data.SqlClient`.

**Non-goals (hard constraints):** No new features. No loyalty changes. No reports beyond what the waiter web module already does. No multi-tenant SaaS. No cloud services. No external NuGet beyond those listed. Do not invent UI flows that don't exist in the legacy web module.

---

## 1. Legacy Source Map (verified file inventory — re-read these if anything is unclear)

| Legacy artifact | Path (this repo) | Lines | Role |
|---|---|---|---|
| Waiter order service (WEB, authoritative) | `SageFrame/Modules/ROPurchaseOrder/ROPurchaseOrderWebService.asmx` | 1358 | Class `RoWebService`, `[ScriptService]`, 14 WebMethods. All order/table/bill logic. |
| Order browsing service (web JS client) | `SageFrame/Services/OrderWebService.asmx` | 765 | Class `OrderWebService`, ~30 methods: menu/categories/items/extras/combos/search/bill data/print count. |
| Restro shared service | `SageFrame/Services/RestroWebService.asmx` | 140 | Roles, PIN settings, CheckPinCodeMatch, shiftItems(Web), getDataForShift, getRooms, getTablesData, SaveSales, SendToCBMS. |
| Login service | `SageFrame/Modules/ROUSER/ROLoginWebService.asmx` | 331 | `Login` (GET!), `CheckLogin`, `LoginPin`, `LoggedOut`, `getWaiterList`, `TestLogin`. |
| Dashboard service | `SageFrame/Modules/RestroDashboard/services/DashBoardWebService.asmx` | ~50 WebMethods | Merge/unmerge, occupied tables/rooms, bookings, shiftTable, checkOrder, unpaid bills. |
| Web client JS (latest behavior) | `SageFrame/js/orders.js`, `SageFrame/js/payment.js`, `SageFrame/js/shiftItems.js`, `SageFrame/js/pincode.js`, `SageFrame/Modules/ROUSER/Js/login.js` | — | Defines baseUrl patterns, `data.d` unwrapping, form vs JSON encoding. **This is the contract.** |
| Module shell | `SageFrame/Modules/ROPurchaseOrder/ROPurchaseOrder.ascx(.cs)`, `ROCheckOrder.ascx.cs` | — | Screen flow of the waiter web UI to replicate. |
| DB scripts sample | `DB/sp1.sql`, `DB/sp2.sql`, `DB/projectdeliakujscript.sql` | — | Stored-procedure style reference. |
| APK (NOT the target, context only) | `RestroWaiterNew/**` | — | Kotlin app hitting `ROPurchaseOrderWebService.asmx` — confirms envelope parsing `{statusCode, message, data}`. |

### 1.1 Transport rules observed in the legacy web clients (MUST be replicated)

The legacy stack is ASMX + `[ScriptService]` + jQuery. Reproduce these behaviors exactly:

- **URL shape:** `POST /<path>/<Service>.asmx/<MethodName>` (case-sensitive method name as in source; note the web JS sometimes uses lowercase `w` in `OrderWebservice.asmx` — route both spellings).
- **Two request encodings coexist:**
  - *Typed-return methods* (`string`/`int`/`ItemsList`/`billingTermAndCostcenter` returns, e.g. `GetCategoriesBymenuID`, `getGlobalizedMenu`, `getmembershiplistbyId`, `getLanguage`): called by orders.js with `contentType: "application/json; charset=utf-8"` and body `{"MenuId":1,"languageid":0}` → **ASMX wraps typed return values in a JSON string under key `"d"`**. Clients then do `JSON.parse(data.d)`. So the HTTP response is literally: `{"d":"[{\"CategoryId\":...}]"}` (the inner payload JSON-escaped as a string). **Your endpoints returning DTOs must produce exactly this `{"d": "<json-string>"}` envelope.**
  - *`void` methods that self-write via `Context.Response.Write(...)`* (PurchaseOrder, UpdateOrder, TableOrderByRoom, CancelOrderIntoDataBase, APIforPay, checkOrder, LoginPin, CheckPin, TableTransfer, RoomOrderByRoomType...): the legacy code calls `Context.Response.Clear(); ContentType="application/json"; Response.Write(<hand-built string>)`. Because the method is `void`, **ASMX does NOT wrap in `d`** — the client receives the hand-written body verbatim. Most of these bodies are **non-strict JSON** (unquoted keys `statusCode`, `message`, `Data`) — e.g. `{statusCode:200, message: "Success"}`. jQuery/JSON.parse-lite and the Kotlin Gson lenient parser tolerate this today. **Reproduce byte-for-byte, including unquoted keys and capitalization quirks (`Data` vs `data` per method — see §3).**
  - *Form-encoded calls:* some clients post `$.post(url, { json: "...stringified..." })` or query-string params (e.g. `Login?Username=x&Password=y` because it has `[ScriptMethod(UseHttpGet=true)]`). Accept both `application/x-www-form-urlencoded` and `application/json` bodies for every method; when JSON, bind parameters by name exactly as in the C# signatures (`json`, `pin`, `tableID`, `MenuId`, `languageid`, `CategoriesID`, `LanguageID`, `Id`, `OID`, `ItemName`, `orderMasterId`, `Printcount`, `BillNo`, `PrintedBy`, `info`, `customer`, etc.).
- **`Login` is HTTP-GET-with-querystring** (`[ScriptMethod(UseHttpGet = true)]`) — keep GET support; also accept POST for safety.
- **Void methods that write nothing** (e.g. `UpdateOrder` guard branch writes `""`; `CancelOrderIntoDataBase(string json)` success path may write bare envelopes; `SaveCanceledItems`) — empty-string body means "no running order" to the legacy UI; preserve that signal.
- **Content-Type of every response:** `application/json; charset=utf-8` (legacy sets `application/json`; jQuery treats either fine, but match it).
- **Dates:** legacy serializes `DateTime` in Microsoft format `"\/Date(1696000000000)\/"` via `JavaScriptSerializer` in some paths and ISO-ish strings via Newtonsoft in others. For `void`+Newtonsoft paths (`UpdateOrder`, `RoomOrderByRoomType`, `TableOrderByRoom`, `checkOrder`) emit Newtonsoft default (`"2026-10-02T14:33:00"`). For `d`-wrapped JavaScriptSerializer paths (`Login`, `CheckLogin`, `LoginPin` data) emit MS-format `/Date(ms)/` since login.js parses accordingly. **Verify against `SageFrame/Modules/ROUSER/Js/login.js` before finalizing.**
- **Timestamps server-side:** always `DateTime.Now` (local server time), never UTC — the legacy BillNo generation depends on local-time string munging (§4.1).

---

## 2. Target Architecture (single deployable)

```
DiningApp/                          ← ONE ASP.NET Core 8 project (net8.0), Microsoft.NET.Sdk.Web
├── DiningApp.csproj                ← Packages ONLY: Microsoft.Data.SqlClient, Newtonsoft.Json, System.Configuration.ConfigurationManager (if needed)
├── Program.cs                      ← Kestrel + IISIntegration, DI, routing, session, startup-migration hook
├── web.config                      ← generated by publish; document hand-tweaks in §9
├── appsettings.json                ← ConnectionStrings:SageFrameDb, AppSettings mirror (OrderPrinting, OrderMenuListType, OrderMenuImageshow, PrintOrderShiftBill, CBMSUrl…)
├── Services/                       ← plain controllers mapped to legacy .asmx URLs (see §3)
│   ├── PurchaseOrderController.cs  // Route prefix "Modules/ROPurchaseOrder/ROPurchaseOrderWebService.asmx" AND compat alias "ROPurchaseOrderWebService.asmx"
│   ├── OrderWebController.cs       // Route "Services/OrderWebservice.asmx" (+ "Services/OrderWebService.asmx")
│   ├── RestroWebController.cs      // Route "Services/RestroWebService.asmx"
│   ├── LoginController.cs          // Route "Modules/ROUSER/ROLoginWebService.asmx" (+ alias)
│   └── DashboardController.cs      // Route "Modules/RestroDashboard/services/DashBoardWebService.asmx" (subset used by waiter flow)
├── Logic/                          ← ported business logic (delta ordering, billing, printing hooks)
│   ├── DeltaOrderEngine.cs         // faithful port of CheckOrder() — §4.1
│   ├── ExtraDiffEngine.cs          // faithful port of CheckExtraItems() — §4.2
│   ├── BillingEngine.cs            // faithful port of APIforPay() — §4.5
│   ├── AuthEngine.cs               // Membership password verify + usp_getUserByPin PIN — §4.6
│   └── PrintRouter.cs              // KOT/BOT routing decision (server-side print trigger points)
├── Data/                           ← Ad-hoc SP layer (no EF)
│   ├── Db.cs                       // connection factory, ExecuteReader/Scalar/NonQuery helpers, TransactionScope-aware
│   ├── Repositories/*.cs           // one repo per aggregate (Orders, Tables, Menu, Sales, Users, Company, CostCenter, BillTerms)
│   └── Migrations/                 // embedded SQL: 000_Baseline.sql, 001_*.sql … + MigrationRunner.cs (§7)
├── Models/                         // DTOs mirroring legacy classes EXACTLY (property names/casing matter for JSON) — §5
└── wwwroot/                        // waiter SPA (§6): index.html, css/, js/, img/, lib/ (vendor jquery optional)
```

Key decisions:
- **Controllers, not WCF/asmx.** Each action takes `[FromForm]/[FromQuery]/[FromBody]` tolerant binding, executes legacy logic, and writes responses with `Response.WriteAsync(envelope)` using **raw string building** for the non-strict envelopes (a tiny helper `LegacyJson.Write(this HttpContext, string rawBody)`), or `{"d": ...}` wrapper helper `LegacyJson.D(this HttpContext, object payload)` that JSON-escapes the serialized payload exactly like ASMX.
- **Session auth:** after successful Login/LoginPin, store username/role/pin-user id in distributed/session state (`AddDistributedMemoryCache` + `AddSession`; behind IIS out-of-process optional later). Every order-writing endpoint requires a session user; legacy had none — enforce it only for the SPA, never break direct API callers (gate by header `X-Dining-Auth` optional).
- **No ORM.** Raw SP calls reproduce legacy DAL semantics (return values, output params, `-1` failure codes).
- **Single process, single port, IIS In-Process.** One app pool identity needs: read/write to DB, write to log folder, access to network printers (raw 9100 socket / shared printer UNC) for KOT.

---

## 3. Complete Endpoint Catalogue (THE CONTRACT — implement all, byte-exact)

Legend: `⟪d⟫` = ASMX `{"d":"<escaped-json-string>"}` wrapper required; `⟪raw⟫` = hand-written body via Context.Response.Write, no wrapper; `⟪empty⟫` = body `""`.

### 3.1 `ROPurchaseOrderWebService.asmx` (class `RoWebService`) — waiter core (14 WebMethods)

| # | Method (exact case) | Signature | Request | Response |
|---|---|---|---|---|
| 1 | `CancelOrderIntoDataBase` | `void CancelOrderIntoDataBase(string json)` | form/json field `json` = OrderMasterClass JSON (needs `OrderMasterID`, `GuestNo`, `TableId`, `CancelReason`, `CancelBy`, `UserName`) | ⟪raw⟫ `{statusCode:200, message: "Success"}` on printed; `{statusCode:100, message: "Print Failed"}` if print returns empty; `{statusCode:100, message: "<ex.Message>"}` on exception. Logic: fetch details where `Status=="Ordered" && SeatNo==GuestNo`; build `OrderDetailCancel` list (Responsible="Customer"); call `rocobj.CancelOrder` + `SaveCanceledItems`; if `AppSettings["OrderPrinting"]=="true"` print "Cancelled" slip with token info (`getOrderNobyOrderMasterId` → OrderNo/TokenNo/CustomerName/Phone); table title fallback `"Table"` when null. |
| 2 | `SaveCanceledItems` | `void SaveCanceledItems(string json)` | `json` = `{"cancelledOrderItems":[OrderDetailCancel...]}` (class `CancelledOrder`) | ⟪raw⟫ `{statusCode:200, message: "Success"}` / `{statusCode:100, message: "<ex>"}` |
| 3 | `PurchaseOrder` | `void PurchaseOrder(string json)` | `json` = full OrderMasterClass incl. `OrderDetailsList[]`, `orderExtraItem[]` | ⟪raw⟫ `{statusCode:200, message: "Success"}` when internal `CheckOrder()` returns 1; `{statusCode:100, message:"Printing Failed"}` when 0; `{statusCode:100, message:"<ex>"}` on outer exception. **Full delta algorithm §4.1.** |
| 4 | `UpdateOrder` | `void UpdateOrder(string json)` | `json` = `RestrOrderInfo` → `{"TableId":"12"}` (string!) | Running order as **pretty-printed Newtonsoft JSON of OrderMasterClass** (Indent Formatting) ⟪raw⟫; **guard:** if `orderMaster==null || BillPaid==1 || IsCancelled==true || TableId==null` → ⟪empty⟫ body `""`. If table `IsTable==false` (room booking) enrich with `RoomBookedDays/RoomRate/RoomTotal/AdvancePaid` from `getRoomBookingInfoByOrderMasterID`. Attach per-line `orderExtraItem` filtered by `ItemID==ROI_ItemId && SeatNo==SeatNo && ord.Status==p.ItemStatus && !IsCombo`. Cost-center carry-forward loop over lines (same GroupId ⇒ reuse previous ccid — comment documents KOT=1, BAR=2, Cake=95, Pizza=97). |
| 5 | `RoomOrderByRoomType` | `void RoomOrderByRoomType(string json)` | `json` = `{"RoomTypeID":n}` | ⟪raw⟫ `{statusCode:200, message:"",Data:<indented List<RestroRoom>>}` (capital **D**ata!) / `{statusCode:100, message:"<ex>"}` |
| 6 | `getGlobalizedMenu` | `void getGlobalizedMenu(int languageid)` | param `languageid` | ⟪raw⟫ indented `List<MenuClass>` (bare array, NO envelope). Legacy also dumps to a .Json file on disk — skip file dump, keep response identical. |
| 7 | `TableOrderByRoom` | `void TableOrderByRoom(string json)` | `json` = `{"restroRoomId":n}` | ⟪raw⟫ indented `List<restroTable>` bare array. **Status inheritance (verbatim):** for each table: if `MergeTableList>0` → copy `BillPaid` & `IsCancelled` from the merged-target table in same list, set `restrotablesStatusID = (BillPaid==1||IsCancelled==1 ? 6 : 7)`; then if `OrderMasterId>0` → statusID=7 else statusID=6 **and force `BillPaid=0`**. (Note the second if/else overrides the first — replicate exactly.) |
| 8 | `GetCategoriesBymenuID` | `void GetCategoriesBymenuID(int MenuId, int languageid)` | params | ⟪raw⟫ indented categories list (also present in OrderWebService as string-return — prefer the void version here matching orders.js which calls the OrderWebService one; implement BOTH routes). |
| 9 | `TableTransfer` | `void TableTransfer(string json)` | `json` = ShifTable `{fromOrderMasterId,toTable,fromSplitNo,toSplitNo,shiftedBy,fromTable,toTable}` | ⟪raw⟫ **BUG-COMPAT REQUIRED:** success body is literally `{statusCode:200, message:"Success", data:{ oldTable:5,  newTable": 7}}` — note the malformed quote after `newTable` and unquoted numbers; exception body is `{"statusCode:100, "message":"<ex>"}` (misplaced quotes). Callers today parse leniently; reproduce character-for-character. Underlying SP call: `roc.shiftTable(fromOrderMasterId,toTable,fromSplitNo,toSplitNo,shiftedBy)`. |
| 10 | `getActiveBillTerm` | `billingTermAndCostcenter getActiveBillTerm()` | none | ⟪d⟫ of `{"billingTerm":[...],"costCenter":[...]}`. **Rule:** if `companyInfo.IsPan == true` → `billingTerm.RemoveAll(d => d.Name == "VAT")`. |
| 11 | `CheckPin` | `void CheckPin(string pin)` | param `pin` | ⟪raw⟫ `{statusCode:200, message: "Success", data:<jss.Serialize(PinUser)>}` with `info.Message="Success"` injected / `{statusCode:100, message: "Invalid Pin"}`. (Legacy dead-code `JsonConvert.DeserializeObject("")` line — ignore.) |
| 12 | `APIforPay` | `void APIforPay(int tableID)` | param `tableID` | ⟪raw⟫ `{statusCode:100, message: "No order in this table"}` when table has no lines; otherwise performs full bill close (§4.5) and (legacy) renders bill HTML — respond `{statusCode:200, message: "Success"}`-style only if legacy did; **legacy writes NOTHING on success path** (billHtml writes to stream? verify: `billHtml(tableID)` builds HTML and sends via print pipeline, not Response) → success = empty body. SPA then reloads `UpdateOrder` to detect closed bill. |
| 13 | `checkOrder` | `void checkOrder(string json)` | `json` = SalesMaster-shaped `{OrderMasterId,SeatNo,TableId}` | ⟪raw⟫ `{statusCode:200, message:"Success", data: <indented List<CheckBill>>}` (lowercase data) / `{statusCode:100, message:"<ex>"}` |
| 14 | *(private, not exposed)* | `PrintExtra(...)`, `CheckOrder(...)`, `CheckExtraItems(...)`, `Getreqiredamount(...)` | — | port into Logic/, never route them. |

### 3.2 `Services/OrderWebService.asmx` (~30 WebMethods — the menu/order-browsing surface used by `orders.js` with `baseUrl = SageFrameHostURL + "/Services/OrderWebservice.asmx/"`)

All below return `string` (→ ⟪d⟫) unless noted; orders.js consumes `JSON.parse(data.d)`:

| Method | Signature | Notes (verified from source lines 26–765) |
|---|---|---|
| `GetCompanyInfoLogo` | `string()` | company logo markup/base64 as legacy returns |
| `GetItemForSearch` | `string()` | all searchable items |
| `GetMenuforOrder` | `string()` | menus list |
| `GetCategoriesBymenuID` | `string(int MenuId, int languageid)` | categories, language-aware |
| `GetItemByCategoryID` | `string(int CategoriesID, int LanguageID)` | items w/ rate, stock flag, image path |
| `getitemforcumbo` | `string()` | combo component items (note typo "cumbo" — keep!) |
| `GetExtraItemsByItem` | `string()` | extra/topping master list |
| `CheckPinCodeMatch` | `string(string PinCode, string username)` | delegates same as RestroWebService |
| `SaveCanceledItems` | `void(List<OrderDetailCancel> CancelItems)` | typed-list binder variant (APK-era) — accept `json` field too |
| `SaveOrderIntoDataBase` | `string(OrderMasterClass orderMasterInfo, List<OrderExtraItem> orderExtraItem)` | typed variant; SPA uses PurchaseOrder instead |
| `GetDataForSalesBill` | `string(int orderMasterId)` | bill print data (used by payment.js via same service) |
| `GetDataForPOSSalesBill` | `string(int orderMasterId)` | POS variant |
| `GetCustomerDatas` | `string(int customer)` | customer/membership snapshot |
| `SaveSalesBill` | `int(SalesMaster, List<SalesDetails>, int splited, List<customerBilling>, flatorperdiscount)` | returns salesMasterId int ⟪d⟫ number |
| `savePrintCount` | `string(int Printcount, string BillNo, string PrintedBy)` | reprint counter |
| `CancelOrderIntoDataBase` | `void(OrderMasterClass orderMasterInfo)` | typed variant |
| `txtSearchForItem` | `string(string ItemName, int languageid)` | live search |
| `GetPreviousItemByID` | `ItemsList(int Id, int OID)` | **typed return** → ⟪d⟫ of `{CompOrders,InPrgOrders,OrderedOrders,AllOrders,orderedExtraItems}` |
| `SaveFoodCourtSalesBillWithPayment` / `SaveFoodCourtSalesPOSBillWithPayment` | `string(..., List<SalesPayment>)` | food-court paths — include for parity even if SPA doesn't use |
| `SaveFoodCourtSalesBill` | `int(..., SalesPayment)` | |
| `GetProviderList` | `string()` | card/payment providers |
| `IsFoodCourtAutoBilling` | `string()` | reads app setting |
| `GetPaymentModesAndProviders` | `string(int salesMasterId)` | used by payment.js |
| `SavePayment` | `void(List<SalesPayment>)` | payment.js |
| `getMemberDetailsbyinfo` | `string(string info)` | membership lookup by card/phone |
| `getmembershiplistbyId` | *(called by orders.js line 63)* | implement matching legacy controller method |
| `getLanguage` | *(called by orders.js line 85)* | language list for menu localization |

### 3.3 `Services/RestroWebService.asmx` (string-return → ⟪d⟫ except noted)

| Method | Signature | Response |
|---|---|---|
| `GetAllUserRoles` | `string()` | ⟪d⟫ `List<PinUser>` (JsonConvert) |
| `GetPinSettings` | `string()` | ⟪d⟫ role-pin settings |
| `CheckPinCodeMatch` | `string(PinCode, username)` | ⟪d⟫ of a **string** value (`"available"`/etc.) — double-escaped, keep |
| `shiftItems` | `string(json)` | ShiftItems JSON → ⟪d⟫ of `{"Success":true,"Message":"Items shifted successfully"}` or `{Success:false, Message:"Shift failed: <ex>"}` (print-shift-bill block commented out in legacy — leave commented behavior) |
| `shiftItemsWeb` | `string(ShiftItems obj)` | typed variant (shiftItems.js posts model-bound) |
| `getDataForShift` | `string(int orderMasterId)` | order lines available for shifting |
| `getRooms` | `string()` | room list |
| `getTablesData` | `string()` | all tables |
| `SaveSales` | `int(SalesMaster,...,SalesPayment,bool isFoodCourt)` | int ⟪d⟫ |
| `SendToCBMS` | `string(int salesMasterId)` | CBMS push (on-prem gateway call; honor `CBMSUrl` setting; no-op success when unset) |

### 3.4 `ROLoginWebService.asmx`

| Method | Signature | Response |
|---|---|---|
| `Login` | `void Login(string Username, string Password)` **UseHttpGet=true** | GET `?Username=&Password=`; internally `LoginUser(JsonConvert.SerializeObject(UserClass{Username,Password,OrderMenuListType,OrderMenuImageshow}))` (Membership verify §4.6); ⟪raw⟫ jss.Serialize(user) pretty via Newtonsoft round-trip → **indented UserClass JSON, no statusCode envelope**; failure = user object with `Status` indicating invalid. login.js branches on parsed fields. |
| `CheckLogin` | `void CheckLogin(string json)` | POST `json` = UserClass JSON; same output as Login |
| `LoginPin` | `void LoginPin(string json)` | `json` = `{"pin":"1234","WaiterIP":"10.0.0.5"}`; `roc.CheckPin(pin)` → PinUser; success ⟪raw⟫ `{statusCode:200, message: "Success", data:<indented PinUser JSON>}` with `Message="Success"`, `OrderMenuListType`, `OrderMenuImageshow` injected; if `Roles != "KitchenOrder"` → `SaveWaiterDetailForNotification(UserClass{Username,WaiterIP})`; fail ⟪raw⟫ `{statusCode:100, message:"Invalid PIN Code."}` |
| `LoggedOut` | `void LoggedOut(string json)` | clears waiter notification registration |
| `getWaiterList` | `void getWaiterList()` | ⟪raw⟫ waiter list |
| `TestLogin` | `void TestLogin()` | empty 200 |

### 3.5 `DashBoardWebService.asmx` — subset the waiter web flow actually touches (from orders.js/shiftItems.js greps): `checkOrder`, `CheckPin`, `GetRolesByUsername`, plus merge/unmerge/occupied-tables used by the table map: `GetOccupiedTables(bool isTable)`, `MergeTables(List<MergeTableInfo>, string[] occupiedTableIds)`, `UnMergeTable(int tableId)`, `GetMergedTables(int tableId)`, `ClearMergeList(int tableId)`, `shiftTable(int fromordermasterid,int totableID,int fromSeatNo,int toSeatNo,string shiftedby,string fromTableTitle,string toTableTitle,int OrderNo)`, `GetRoomByRoomTypeId(int RoomTypeID)`, `GetUnpaidBills()`, `Gettabledataforshift()`. Implement these with their legacy envelopes (string→⟪d⟫, void→⟪raw⟫/empty).

---

## 4. Business Logic — Faithful Ports (line-by-line requirements)

### 4.1 `CheckOrder` delta-ordering engine (ROPurchaseOrderWebService.asmx lines 205–410) — THE most critical algorithm

Input: `OrderMasterClass json1` (deserialized from `json`), then:

1. `json1.Date = DateTime.Now` (server local).
2. **Re-price every incoming line server-side** (never trust client rates): for each `orderDetailList[i]`: itemList = `getitemwithRateForCombo(ItemId)` if `IsCombo` else `getitemwithRate(ItemId)`; take `itemList[0].SRate`; `Rate = decimal.Parse(SRate)`; `Amount = Rate * Quantity`; accumulate `BasicAmount`. ⚠️ Legacy quirk: it builds a NEW `OrderDetailClass orderDetail` for pricing but sums into BasicAmount — the seat clamp `orderDetail.SeatNo = (SeatNo <= GuestNo ? SeatNo : GuestNo)` applies to that temp object; when porting, apply clamping to the actual line (`ord.SeatNo > json1.GuestNo ⇒ ord.SeatNo = json1.GuestNo`) — the legacy net effect on saved rows comes from `SaveOrderIntoDataBase` receiving original lines; keep saved-seat semantics equal to legacy by clamping inside the repository save exactly as the legacy DAL does (re-verify `RestrOrderController.SaveOrderIntoDataBase` before shipping).
3. **Room resolution:** if `json1.RoomId==0 && json1.OID==0 && TableId!="0"` → `room = GetRoomByTable(TableId)`; if `TableId=="0"` → `getRestroRoomById(RoomId)`; set `RoomId`, `restroRoom`.
4. **BillNo:** `"RO" + Date.ToString().Replace("/","").Replace("PM","").Replace("AM","").Replace(":","").Replace(" ","")` — culture-dependent ToString of DateTime (en-US default on legacy servers). Reproduce with the same chain on `DateTime.Now.ToString()` under `CultureInfo` configured identically (make culture configurable; default en-US).
5. `TermAmount = BasicAmount`; `BillPaid ??= 0`; `Status = ""` (empty string!); `Remarks` default `"Fine"` when null/empty.
6. **Delta vs last saved state** (`lst = GetOrderDetailsByMaster(json1.OrderMasterID)`):
   - If `lst.Count > 0`, for each incoming `ord`:
     - `prevOrders = lst.Where(p => p.ItemId==ord.ItemId && p.IsCombo==ord.IsCombo && p.SeatNo==ord.SeatNo && p.Status=="Ordered")`.
     - Match found & `ord.Quantity > Σprev` ⇒ **ADD partial**: `ord.Quantity -= Σprev`; `ord.Note = ord.Note.Substring(ord.Note.LastIndexOf(';')+1)` (strip everything up to last `;` — client sends cumulative notes with `;` separators); Status="Ordered"; → addedOrders.
     - Match & `ord.Quantity < Σprev` ⇒ **CANCEL partial**: `ord.OrderDetailsID = 0`; `ord.Quantity = Σprev - ord.Quantity`; Status="Ordered"; → cancelledOrders.
     - Match & equal ⇒ no-op (silent).
     - No match ⇒ **NEW item**: Status="Ordered"; → addedOrders (legacy subtracts `Σprev`=0 — harmless).
     - Then reverse sweep: every saved `Status=="Ordered"` line whose `(ItemId,SeatNo,IsCombo)` triple is absent from incoming list ⇒ whole-line phantom cancel → cancelledOrders.
   - Else (first save): all incoming Status="Ordered"; addedOrders = all.
7. Persist: `ordermasterid = rocobj.SaveOrderIntoDataBase(json1, addedOrders, cancelledOrders)` — **TransactionScope wrapping** in legacy DAL: master upsert, added inserts, cancelled marks (`Status="Cancelled"`, cancel reason columns), returns new/current master id. Keep one transaction; on failure surface ex.Message into the 100 envelope.
8. Token: `toke = getOrderNobyOrderMasterId(ordermasterid)` → `OrderNo, TokenNo, CustomerName, Phone` for slips.
9. **Extras diff** (`CheckExtraItems`, §4.2) → `addedExtra`, `removedExtra`; `SaveExtraOrderedItem(addedExtra, removedExtra)`.
10. **Printing (only if `AppSettings["OrderPrinting"]=="true"`)** — build toppingOnly list: for each addedExtra with NO corresponding added main line ⇒ slip `{ItemName=ext.ExtraItem, Quantity=ext.Quantity, Note=<ROI_ItemName of the pre-existing parent line>}`; same for removedExtra with negative quantity. Append extras text to notes of added/cancelled lines: `ord.Note += "Extra : " + Σ(e.ExtraItem + " (" + e.Quantity + ")")` (no separator between multiple extras — legacy concatenates directly; keep). Then:
    - `json1.IsCancelled==true` ⇒ print entire `orderDetailList` as **"Cancelled"** slip.
    - else print addedOrders as **"Added"** slip (if any), cancelledOrders as **"Cancelled"** slip (if any), toppingOnly via `PrintExtra(...)` (status code 1).
    - Any print exception ⇒ return 0 ⇒ client sees `{statusCode:100, message:"Printing Failed"}`.
    - When OrderPrinting != "true" ⇒ return 1 immediately (no printing).
11. Slip header/footer content comes from `OrderPrint.PrintOrders(list, tableTitle, date, userName, statusWord, orderMasterId, OrderNo, TokenNo, CustomerName, Phone)` — port the ticket layout: table title (fallback `"Table"`), status banner (Added/Cancelled), per-line qty/item/note, token & order no, time. Routing: KOT vs BAR vs Kitchen printers decided by line `CostCenterId` (1=KOT, 2=BAR, 95=Cake, 97=Pizza) and the legacy `OrderPrinting`/printer-name app settings — read `SageFrame.RestroOrder/OrderPrint*` sources for exact template and printer selection; replicate destination config keys in appsettings.

### 4.2 Extras diff (`CheckExtraItems(extra, added, ordermasterid, newOrdermasterid)`)

- Added pass: for each incoming ext, prev = ordered extras of OLD master matched by `ItemID+SeatNo+ItemStatus=="Ordered"+ExtraItemID`; `ext.Quantity > prevQty` ⇒ emit delta row (Quantity=diff, OrderMasterId=new).
- Removed pass (only when old `ordermasterid > 0`): `ext.Quantity < prevQty` ⇒ emit positive diff; then reverse sweep: previously-ordered extras absent from incoming list ⇒ emit whole row.
- Same pattern as §4.1 lines; keep `FirstOrDefault().Quantity` semantics (multiple prev rows collapse to first — legacy quirk, preserve).

### 4.3 `CancelOrder` path (method #1 in §3.1) — cancel-all-on-seat: filter `Status=="Ordered" && SeatNo==GuestNo`, build `OrderDetailCancel` rows (Reason from payload, Responsible="Customer", CanceledBy, OrderBy=UserName, tableId from `GetTableNoBYId`), save, print Cancelled slip, envelope per table.

### 4.4 Table transfer / shift / merge
- `shiftTable(fromOrderMasterId, toTable, fromSplitNo, toSplitNo, shiftedBy)` — SP moves split-seat lines between masters; seats outside transferred range stay. Dashboard variant adds titles+OrderNo for the shift slip.
- `TableOrderByRoom` status inheritance — verbatim in §3.1 #7.
- Merge/unmerge: `MergeTables(list, occupiedIds)` creates merge links (`MergeTableList` column), `GetMergedTables(tableId)` lists members, `ClearMergeList(tableId)` breaks link, `UnMergeTable(tableId)` full unmerge incl. restoring independent statuses.
- `shiftItems` (RestroWebService): move selected order lines from one table/master to another (`ShiftItems` model: OrderMasterID, fromTableTitle, toTableTitle, shiftedBy, OrderNo, item list) — SP-backed.

### 4.5 `APIforPay` billing engine (lines 851–1030) — replicate arithmetic EXACTLY, in this order:

1. `orderMasterList = GetAllOrder(0,false,tableID)`; `lst = GettabledataById(tableID)`. Empty ⇒ `{statusCode:100, message: "No order in this table"}`. Guard `lst[0].OrderDetailsID != 0`.
2. `amount = Σ (Amount + (Amount!=0 ? ExtraCharge*Quantity : 0))` over all lines (KOT side). `bevrage = Σ (Bevrage + (Bevrage!=0 ? ExtraCharge*Quantity : 0))` (BAR side — `Bevrage` is a per-line beverage subtotal column).
3. Cost-center discounts: `cuscenter = getdiscountfromcostcenter()`; `kotdisamount = cuscenter[0].coDiscount`, `bevdisamount = cuscenter[1].coDiscount` (index order matters!). `kotdis = amount - amount*kotdisamount/100` (when amount≠0), `bevdis = bevrage - bevrage*bevdisamount/100` (when ≠0). `totaldiscount = amount*k/100 + bevrage*b/100`. `sum = kotdis + bevdis`.
4. Terms: `term = getActiveBILLTERM()` (ordered list of `{ID,BillTerm,Rate,IsAdd}`). Sequential application starting `total = sum`:
   - **When `tableID == 0` (walk-in/takeaway master):** skip term named exactly `"Service Charge"` entirely (not applied, not emitted).
   - Per applied term: `term[i].Amount = Convert.ToDecimal((total * Rate / 100).ToString("0.00"))` (banker-free 2-dp truncation-style rounding via ToString — use `decimal.ToString("0.00")` + Parse, MidpointRounding as .NET ToString gives); then `total += total*Rate/100` if IsAdd else `total -= total*Rate/100` (⚠️ the running-total update uses the UN-rounded product while the displayed Amount is rounded — legacy inconsistency; reproduce exactly).
   - Append synthetic term `{ID=1, BillTerm="NetAmount", Rate=0, Amount=total.ToString("0.00") parsed}`.
5. `SalesMaster sm`: `billNo=""`, `BillDate=DateTime.Now`, `BasicAmount = lst[0].BasicAmount - totaldiscount`, `RoomId/TableId` from `orderMasterList[0]`, `OrderMasterId = orderMasterList[last].OrderMasterID`, `totaldiscount`, `TermAmount=0`, `NetAmount=total`, empty Cus/PAN/Cheque/Transaction, `CusID=0`, `sumKot=kotdis`, `sumBev=bevdis`, `Waiter=""`, `SPMID=0`, `IsSplit=0`, `SeatNo=1`, `AddedBy=""`.
6. Emit list `bt` of `{ID,Amount,Rate}`: **skip the LAST term (NetAmount)** from `sm.TermAmount` accumulation (`if (count != term.Count()-1) sm.TermAmount += term[count].Amount; count++`) but still add it to `bt` — note when `orderMasterList[0].TableId=="0"` Service-Charge entries are excluded from `bt` as well. (Careful: legacy increments `count` inside the skip-guard AND appends bts outside — reproduce the off-by-one exactly; it determines which terms land in TermAmount.)
7. `sd` lines: `{ItemId=ROI_ItemId, qty=Quantity, rate=SRate, Amount, NetAmount=Amount, OrderDetailsID, CostCenterId, IsCombo}`.
8. `flatorperdiscount fl`: `{SalesMasterId=sm.salesMasterId(0), kotdis=kotdisamount.ToString(), bardis=bevdisamount.ToString(), isflatdis=false, isLoyalty=false, loyaltydis="0", roomdis="0"}` → `saveflatorperdis(fl)`; then `saveSalesBill(sm, sd, 0, bt)` (SP closes order: writes sales master/details/terms, marks order BillPaid, frees table). Finally `billHtml(tableID)` — generates the customer invoice HTML (logo/name/address/phone/TAX INVOICE/VAT No=PAN, lines, terms, amount-in-words via NumberToEnglish) and sends to the bill printer. Port the HTML template verbatim from lines 1056–1358 and the print dispatch; do not return it in the API body.
9. **VAT removal rule lives in `getActiveBillTerm` (§3.1 #10) for the PREVIEW path; `APIforPay` uses raw `getActiveBILLTERM()`** — meaning paid bills keep VAT unless SP-level config removes it; reproduce precisely (do not "fix" it).

### 4.6 Auth
- **PIN:** `usp_getUserByPin`-backed `roc.CheckPin(pin)` → `PinUser{UserName,Roles,Pin,...}`. KitchenOrder role skips waiter-notification registration.
- **Password:** SageFrame Membership compatibility: users live in legacy `aspnet_*`/SageFrame security tables; verification = SHA256(password + salt/configKey) per SageFrame.Security machineKey configuration (read `SageFrame/Modules/ROUSER/ROLoginWebService.asmx` `LoginUser` + `SageFrame.Security` config to extract the exact hashing/salt derivation and `machineKey` validation algorithm). Rijndael/AES helper exists for other payloads — only replicate what LoginUser actually calls. Session cookie issued after success.

### 4.7 Misc contracts
- `savePrintCount(Printcount, BillNo, PrintedBy)` — increments reprint counter, returns status string.
- `GetPreviousItemByID(Id, OID)` — ItemsList buckets Comp/InPrg/Ordered/All + orderedExtraItems (statuses drive the "previous orders" tab).
- Stock: legacy `IsAutoPurchase` app setting triggers purchase-consumption postings on order save — gate identically (call same SPs; no-op when setting off).

---

## 5. Data Layer & DTOs

- **DTOs** (Models/) must mirror legacy property names/casing **exactly** because JSON keys are consumed by clients: `OrderMasterClass` (OrderMasterID, OID, TableId(string), RoomId(int), restroRoom, GuestNo, Date(string), BillNo, BasicAmount, TermAmount, BillPaid(int?), Status, Remarks, UserName, CancelReason, CancelBy, IsCancelled(bool), OrderDetailsList, orderExtraItem(lowercase o)), `OrderDetailClass` (OrderDetailsID, ItemId, ROI_ItemId, ROI_ItemName, Name, Quantity, Rate, SRate, Amount, Bevrage, ExtraCharge, SeatNo, Note, Status, IsCombo, CostCenterId, GroupId, orderExtraItem, Date, CusName, PAN, Address, salesMasterId, GetBillNo()), `OrderExtraItem` (ItemID, ExtraItemID, ExtraItem, ExtraPrice, Quantity, SeatNo, OrderMasterId, ItemStatus), `OrderDetailCancel`, `ShifTable`, `ShiftItems`, `RestrOrderInfo` (TableId, RoomTypeID, restroRoomId), `restroTable` (restrotableId, restrotableTitle, restrotablesStatusID, BillPaid, IsCancelled, MergeTableList, OrderMasterId, IsTable, OrderNo…), `RestroRoom`, `MenuClass`, `categoryClass`, `itemsClass`, `ROInvItem` (SRate…), `SalesMaster`, `SalesDetails`, `customerBilling` (ID, BillTerm, Rate, Amount, IsAdd), `billingTermAndCostcenter`, `costCenter` (coDiscount), `flatorperdiscount`, `PinUser`, `PinLogin`, `UserClass` (Username, Password, Status, Roles, WaiterIP, OrderMenuListType, OrderMenuImageshow, Message), `Token`, `CheckBill`, `companyInfo` (Name, Address, PhoneNo, PAN, Logo, IsPan), `MergeTableInfo`, `MemberInfo`, `SalesPayment`, `RoomBookingsInfo`. Pull exact member lists from `SageFrame.RestroOrder` class files before coding each.
- **Repositories call the SAME stored procedures** the legacy DAL used (discover names by reading `SageFrame.RestroOrder/*Provider*.cs` — e.g. `usp_Restro_*`, `usp_SaveOrder...`, `usp_getUserByPin`, `usp_CheckPinCodeMatch`, sales/order/table SPs). Parameter names/types copied from provider code. No inline SQL except where legacy used inline.
- `Db.cs`: `SqlConnection` from `ConnectionStrings:SageFrameDb`; helpers `Query<T>(sp, params, mapper)`, `Execute`, `ExecuteScalar`; ambient `TransactionScope` support (legacy DAL wrapped multi-SP writes).

---

## 6. Waiter SPA (wwwroot) — screens & behavior (mirror the legacy web module ONLY)

Vanilla ES2020 + CSS grid/flex; no framework; works offline-ish (LAN only); viewport-responsive from 320px phones to 4K; touch targets ≥44px; landscape-first tablet layouts; dark kitchen mode for KitchenOrder role. Vendor jQuery 3.x allowed solely to reuse legacy ajax idioms if convenient, but native fetch preferred.

1. **Login screen** — two modes: username/password (calls `Login`) and numeric PIN pad (calls `LoginPin` with `{pin, WaiterIP}` — capture client IP server-side as fallback). Persist session; remember last user for fast re-login (device-local).
2. **Room/Table map** — pick RoomType → `RoomOrderByRoomType` → rooms; pick room → `TableOrderByRoom` → table tiles colored by `restrotablesStatusID` (6=free/grey-green, 7=occupied/orange/red per legacy CSS in ROPurchaseOrder.ascx styles — extract exact colors/classes from the ascx/css). Tap occupied tile → running order; tap free tile → open new order (guest count dialog → SeatNo clamp semantics). Actions per table: **Transfer** (`TableTransfer`), **Merge/Unmerge** (dashboard endpoints), **Shift items** (shiftItems screen), **Bill** (`APIforPay`), **Cancel order** (reason dialog → `CancelOrderIntoDataBase`).
3. **Running order screen** — `UpdateOrder({TableId})`; empty response ⇒ toast "Bill already paid/closed" and back to map. Group lines by SeatNo; show qty, rate, amount, notes, extras chips; edit quantities (client accumulates deltas with `;`-separated Note convention), remove lines (set qty 0 ⇒ phantom-cancel path), add extras per line (`GetExtraItemsByItem`), remarks default "Fine". Submit ⇒ serialize full OrderMasterClass (including ALL current lines + extras) ⇒ `PurchaseOrder`; handle `{statusCode:100,message:"Printing Failed"}` with retry prompt (legacy UX).
4. **Menu screens** — `getLanguage` → language picker; `GetMenuforOrder` → menu; `GetCategoriesBymenuID` → category tabs; `GetItemByCategoryID` → item cards (image per `OrderMenuImageshow`, list/grid per `OrderMenuListType` — these two app-settings MUST drive layout, exactly like legacy); `txtSearchForItem`/`GetItemForSearch` live search; `getitemforcumbo` combo builder (component selection); stock-out badge; quantity stepper w/ seat selector (clamped to guest count).
5. **Check bill** — `checkOrder({OrderMasterId,SeatNo,TableId})` per-seat totals preview; **Close bill** — `APIforPay(tableID)` then reprint via `GetDataForSalesBill` + `savePrintCount`.
6. **Previous orders tab** — `GetPreviousItemByID` buckets (Completed/In-progress/Ordered/All).
7. **Shift items screen** — `getDataForShift` + `getRooms`/`getTablesData` + `shiftItemsWeb`; **Transfer table** dialog; **Cancel items with reason** dialog (`SaveCanceledItems`).
8. **Kitchen view** (role KitchenOrder): read-only live list of added/cancelled slips (poll `checkOrder`/`GetPreviousItemByID` like legacy polling interval — replicate interval).
9. Toasts/modals styled like legacy module; every button maps 1:1 to an endpoint in §3. **No feature exists that isn't in §3; no §3 capability hidden from the UI.**

State: sessionStorage cart mirror keyed by table; naive polling refresh (legacy cadence) — no SignalR (not in legacy).

---

## 7. AUTO-MIGRATION FEATURE (startup, zero-touch)

Implement `MigrationRunner` invoked from `Program.cs` before `app.Run()`:

1. Connect to `ConnectionStrings:SageFrameDb`. Create DB if absent? **No** — on-prem installs restore the existing backup first; instead **verify baseline**: assert presence of required tables/SPs (list compiled from the repositories' SP inventory: e.g. order master/detail tables, restro tables/rooms/roomtypes, menu/category/item/extras, sales master/details/terms/payments, canceled-items, print-count, aspnet_/security tables, and every SP referenced in §5). Missing baseline ⇒ log actionable error + friendly maintenance page (don't crash-loop IIS).
2. `dbo.DiningApp_MigrationHistory` table (auto-created): `Id, Version(nvarchar 50), Name, AppliedOn, Checksum`.
3. Embedded resources `Data/Migrations/NNN_Name.sql` executed in ascending order inside transactions; additive-only DDL/seed (ALTER VIEW, CREATE PROCEDURE wrappers, indexes, config rows). Checksum drift detection ⇒ warn.
4. Idempotent seed of app-config rows the app needs that legacy kept in web.config (OrderPrinting, OrderMenuListType, OrderMenuImageshow, printer mappings) into a small `DiningApp_Settings` table readable-overridable by appsettings.json.
5. Expose `GET /health` (DB reachable, migration state, version) and `GET /api/version`. Log to `App_Data/logs/yyyyMMdd.log` (roll daily; IIS write perms documented).
6. Multi-instance safety: `sp_getapplock` around runner.

---

## 8. Printing & Cash Drawer (on-prem reality)

- Port `OrderPrint` destinations: raw TCP 9100 ESC/POS and/or Windows shared printer by name; config keys per station (KOT printer, BAR printer, Bill printer, Kitchen slip). Ticket templates (Added/Cancelled/Shift/Bill/KOT/BOT) copied from legacy `SageFrame.RestroOrder` print classes — monospace 80mm default, widths configurable.
- Print failures MUST surface exactly as legacy (`"Printing Failed"` / `"Print Failed"` envelopes) so waiter retry UX works.
- Drawer kick pulse included in bill slip bytes as legacy does (verify in OrderPrint source).

---

## 9. IIS Deployment (deliver as `deploy/` folder + README)

1. `dotnet publish -c Release -o publish` → copy to `C:\inetpub\DiningApp`.
2. IIS: Application Pool ".NET CLR Version = **No Managed Code**", enable 32-bit false (unless x86 drivers needed), Identity = domain/service account with DB + printer access. Site binding http://:80 (or https with cert). Application → point to publish dir. Install **ASP.NET Core Hosting Bundle** on server.
3. `web.config` (auto-generated) — document additions: `<handlers>` aspNetCore, `requestTimeout` for slow prints, static content caching for wwwroot, session affinity N/A (sticky via ARR optional for web-garden; recommend single worker process).
4. `appsettings.Production.json` next to exe (connection string with `TrustServerCertificate=True;MultipleActiveResultSets=True`), rotated secrets via Windows DPAPI optional.
5. Firewall: inbound 80/443; outbound SQL 1433 + printer IPs/9100.
6. Update path: stop pool → replace folder → start pool → migrations run automatically → `/health` green. Rollback = swap folder back (migrations additive-only ⇒ safe).
7. Root-site compatibility option: if customers want the app under the existing SageFrame host name, ship rewrite rules mapping `/Services/...asmx/...` and `/Modules/ROPurchaseOrder/ROPurchaseOrderWebService.asmx/...` virtual paths to DiningApp (IIS sub-application at `/` with identical routes already satisfies these paths — routes in §3 use the FULL legacy paths so a standalone site is drop-in).

---

## 10. Definition of Done / Parity Checklist (run before claiming completion)

- [ ] Every §3 method routed at its legacy URL (both casing aliases), correct ⟪d⟫/⟪raw⟫/⟪empty⟫ envelope, correct Content-Type.
- [ ] Byte-diff harness: replay captured legacy request bodies (unit-test fixtures built from `*.Json` dump files in `Modules/ROPurchaseOrder/`) against new app pointed at a restored copy of production DB; responses must match modulo whitespace where legacy was pretty-printed.
- [ ] `TableTransfer` malformed-JSON bug reproduced exactly; `RoomOrderByRoomType` capital-`Data` reproduced; `getGlobalizedMenu` bare-array reproduced.
- [ ] Delta engine unit tests: add-new, add-more (qty delta + note-after-last-semicolon), reduce-qty (cancel diff), remove-line (phantom cancel), extras add/reduce/remove, topping-only slips, equal-qty no-op, first-save passthrough, seat clamp to GuestNo, BillNo format, Remarks "Fine".
- [ ] Billing tests: KOT/BAR discount indices [0]/[1], `ToString("0.00")` amounts vs un-rounded running total, Service-Charge skip only when tableID==0 / TableId=="0", NetAmount appended, TermAmount off-by-one accumulation, VAT removal only in `getActiveBillTerm`, empty-table message.
- [ ] Guards: `UpdateOrder` returns `""` when BillPaid==1/IsCancelled/null; `APIforPay` "No order in this table".
- [ ] Auth: PIN success/fail envelopes; KitchenOrder skips waiter registration; password hash matches legacy vectors.
- [ ] Auto-migration: fresh DB (baseline restored) starts clean; second start no-ops; tampered migration checksum warns; concurrent starts lock-safe.
- [ ] SPA: all §6 screens functional at 320px/768px/1024px/1440px/2160px; touch-only navigation possible; OrderMenuListType/Imageshow toggles honored; Printing-Failed retry UX.
- [ ] Zero references to SageFrame assemblies, System.Web, or WebForms anywhere in DiningApp.
- [ ] `dotnet build` warning-free; `dotnet test` green; publish folder runs under IIS In-Process on a clean Windows Server with Hosting Bundle only.

## 11. Suggested Implementation Order

1. Scaffold project + Db.cs + MigrationRunner skeleton + health.
2. DTOs (§5) from legacy class files.
3. Read-only endpoints (menu/catalog/rooms/tables/billterms/checkOrder) → parity fixtures.
4. Auth (PIN first, then password).
5. DeltaOrderEngine + PurchaseOrder/Cancel/SaveCanceled + extras diff + print stub switch (OrderPrinting=false during dev).
6. BillingEngine + APIforPay + billHtml/port print router.
7. Transfer/merge/shift family.
8. SPA screens in §6 order, wiring each to real endpoints.
9. Printing integration on lab hardware, then parity harness (§10) against restored prod DB, then deploy pack §9.

*(End of master prompt — everything herein was verified against the repository files listed in §1 on 2026-10-02.)*
