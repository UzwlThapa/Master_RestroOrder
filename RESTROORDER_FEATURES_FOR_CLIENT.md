# RestroOrder — Complete Feature List for Client Quotation
### Industrial-Grade Restaurant POS & Dining Management Software
*Prepared from verified source-code audit of the live SageFrame RestroOrder module (100+ modules, 40 web services). Every feature listed below exists in the current production software — nothing hypothetical.*

---

## 🎯 Executive Summary (The Elevator Pitch)

**RestroOrder is a complete, on-premise restaurant and multi-outlet dining management system** — from the moment a guest is seated at a table, through order-taking, KOT printing to the kitchen, bill splitting, payment settlement, all the way to daily closing, audit reports and stock accounting. It runs entirely on the client's own server (Windows/IIS + SQL Server), meaning **zero cloud dependency, zero per-transaction fees, and 100% data ownership** — with a mobile-ready waiter app that works across every device.

---

## ⭐ Unique Selling Propositions (USPs)

| # | USP | What It Means For The Client |
|---|-----|------------------------------|
| 1 | **100% On-Premise — Your Data, Your Server** | No SaaS subscription, no monthly per-terminal fee, no internet lock-in. Billing keeps running even if the internet goes down. All guest & sales data stays inside the client's building. |
| 2 | **One System, Every Outlet** | Multi-restaurant / multi-cost-center ("outlet") support under one login — Banquet, Kitchen, Bar, Coffee Shop, Room Service each get separate menus, pricing, discounts and reports, yet consolidate into one company ledger. |
| 3 | **Table → Seat Level Precision** | Not just "Table 5 occupied" — the system tracks *per seat* ordering, so 8 guests at one table can order separately, bills can be split by seat, and tables can be merged/unmerged or transferred mid-service without losing any order line. |
| 4 | **Smart Delta Ordering Engine** | Waiters can modify an already-sent order (add items, cut quantities, cancel lines with reason codes) — the engine prints *only the changed lines* on fresh KOT slips, never re-printing the whole order. Saves paper, saves kitchen confusion, creates a full audit trail. |
| 5 | **Kitchen Routing Built-In** | Each menu item knows its destination: KOT printer, Bar printer, Beverage slip, or topping-only mini-slip. Printing is server-driven — the waiter device needs no printer drivers at all. |
| 6 | **Dual Login for Speed** | Managers log in with username/password; floor staff punch in with a fast numeric PIN (configurable PIN policy). Shift handover, drawer open/close and counter-person accountability are built around this. |
| 7 | **Full Nepal-style Bill Terms Engine** | Auto service charge, VAT handling (pan/no-pan companies), cost-center-wise discount rules, sequential billing terms with exact paisa rounding — the bill math matches statutory requirements to the last decimal. |
| 8 | **Waiter App = Web App Now** | The latest web-grade API powers both the browser interface and the Android waiter app — one codebase, one upgrade path, responsive on phones, tablets, desktops and terminals of any size. |
| 9 | **Auto Database Migration** | New version? The app migrates its own database schema on startup — versioned, additive-only scripts run automatically. No DBA visit, no downtime script babysitting. |
| 10 | **Traceable Everything** | Cancel reasons, cancelled-bill reports, print counts, shift items between outlets, complementary (free) item tracking — designed for auditor-proof operations. |

---

## 📋 Full Feature Catalogue

### 1. Login, Users & Security
- ✅ Username + password login (enterprise membership security)
- ✅ **Quick PIN-code login** for floor staff (`CheckPinCodeMatch`) with configurable PIN settings
- ✅ Role-based user management (ROUSER module) — Admin, Manager, Cashier, Waiter, Captain roles
- ✅ User role listing & assignment (`GetAllUserRoles`)
- ✅ Session/status pages and license-expiry guard screens

### 2. Company & Outlet Setup
- ✅ Company profile with logo (`GetCompanyInfoLogo`, ROCompanyInfo) — printed on every bill/KOT
- ✅ Fiscal year management
- ✅ Cost centers = outlets (Restaurant, Bar, Kitchen, Banquet…) with cost-center assignment per user/table
- ✅ Room types → Rooms → Tables hierarchy (RoRoomType, RORoom, RORestroTable)
- ✅ Table master: capacity, seating, status, layout per room
- ✅ Menu master: categories (`GetCategoriesBymenuID`), items with rate/short-code/barcode (ROI_Item, ROMenu)
- ✅ **Combo / package packs** (ROCumboPack, `getitemforcumbo`) — set-menus billed as one unit
- ✅ **Extra/add-on items** per item (`GetExtraItemsByItem`) — e.g., extra cheese, size, spice level
- ✅ Item display/order-layout customization (ROItemDisplay, ROrderLayout)
- ✅ Ingredient/BOM master (ROIngredient, IngredientItem) with units (ROUnit, ROIUnitDefine)
- ✅ Item rate slabs & rate changes (ROI temRate, ROI_ExtraItems)

### 3. Table & Floor Management
- ✅ Live **table map** by room (`getTablesData`, `getRooms`) — occupied / vacant / reserved at a glance
- ✅ Open table with guest count; seats clamped to actual guest number
- ✅ **Merge tables** (MergeTable module) — combine two tables into one bill
- ✅ **Unmerge** with correct bill-status inheritance (paid/cancelled flags carry over safely)
- ✅ **Table transfer** — move a running order to another table, seat numbers split correctly
- ✅ **Table reservation** (RoTableReservation + ReservationService) with reservation report
- ✅ Dinning front page — visual occupancy dashboard (Dinning module)
- ✅ Call-waiter requests surface (CallWaiter module)

### 4. Order Taking (Waiter App / Web)
- ✅ Category-wise menu browsing with search (`txtSearchForItem`, `GetItemForSearch`, `getGlobalizedMenu`)
- ✅ **Multi-language / globalized menu** (`getLanguage`, Globalization module)
- ✅ Per-seat ordering within one table
- ✅ Add / increase / decrease quantities after KOT — **delta engine prints only the change**
- ✅ Line-level remarks ("Fine", special instructions) auto-tagged
- ✅ **Cancel order lines with reason** (`CancelOrderIntoDataBase`, `SaveCanceledItems`) — kitchen gets a cancellation slip automatically
- ✅ Running order view per table (live subtotal, item list, who ordered what)
- ✅ Previous-item quick re-order (`GetPreviousItemByID`) — "the usual, please" in one tap
- ✅ Food-court mode: auto-billing toggle (`IsFoodCourtAutoBilling`) for counter-service outlets
- ✅ Stock-aware ordering — item availability from live inventory

### 5. Kitchen & Printing
- ✅ Automatic **KOT (Kitchen Order Ticket)** routing per item
- ✅ Separate bar/beverage slip routing
- ✅ Topping-only mini-slips
- ✅ Server-side printer configuration (OrderPrinting setting) — devices need no drivers
- ✅ Print-count tracking per document (`savePrintCount`) — reprint audit
- ✅ Raw ESC/POS printing integration (PrintRaw component) incl. cash-drawer kick

### 6. Billing & Payment
- ✅ **Check bill** (pre-bill preview with all charges)
- ✅ Full **bill terms engine**: service charge %, cost-center discounts, sequential term application, exact `0.00` rounding
- ✅ VAT logic tied to company PAN status (auto-added / auto-removed correctly)
- ✅ Multiple **payment modes & providers** (`GetPaymentModesAndProviders`, `GetProviderList`, ROISalesPaymentMode) — cash, card, wallet, credit
- ✅ **Split bill / seat-wise bill** and payment against parts
- ✅ Save sales bill (`SaveSalesBill`), food-court POS bills (`SaveFoodCourtSalesPOSBillWithPayment`)
- ✅ Membership/loyalty applied at billing: member lookup by phone/info (`getMemberDetailsbyinfo`, `getmembershiplistbyId`), loyalty cards (LoyalityCardType, RestroLoyalty)
- ✅ Customer master + customer credit & balance tracking (AddCustomer, CustomerCredit, CustomerBalanceReport)
- ✅ Agent & vendor masters (AddAgent, AddVendor)
- ✅ Complementary / free-of-charge items with approval tracking (RestroComplementary, ComplementReport)
- ✅ Advance HTML/custom bill footers, logo & branding on invoices

### 7. Counter, Drawer & Shift Control
- ✅ **Open drawer / close drawer** sessions (Roi_OpenDrawer, Roi_CloseDrawer) with opening/closing cash entry
- ✅ **Vault report** (Roi_VaultReport) — cash position reconciliation
- ✅ Counter person & counter total tracking (Roi_CounterPerson, Roi_CounterTotal)
- ✅ **Shift items between outlets** (`shiftItems`, `getDataForShift`) — move stock/orders Kitchen→Bar etc. with full trail
- ✅ Send-to-CBMS hook (`SendToCBMS`) for central accounts integration

### 8. Inventory & Accounts (Back Office)
- ✅ Purchase orders (ROPurchaseOrder, RoiPurchase) & goods receive (ROIGoodsReceive, RoiGoodsReceiveReport)
- ✅ Store / warehouse management (ROISTORE) with auto stock adjustment on sales & cancellations
- ✅ Issue slips & consumption register (ROIIssue, ConsumptionReport)
- ✅ COGS costing (RO_Cogs) and item balance ledger (ItemBalance, ItemLedger)
- ✅ Sales return & purchase return (SalesReturn, PurchaseReturn)
- ✅ Daily chalan generation (DailyChalan)
- ✅ Chart of accounts, journal & account reports (ChartOfAccount, ROAccount, AccountReport)
- ✅ Pur register / tax register (PurRegister)

### 9. Reports Suite
- ✅ Sales summary per outlet/day (`ROSalesSummary`)
- ✅ Item-wise sales report (RoItemSalesReport, ItemSalesReport)
- ✅ Bill-wise & un-paid bills (BillsReport, UnPaid-Bills)
- ✅ **Cancelled bill report** (Roi_CancelledBillReport) — audit favorite
- ✅ Closing reports daily/monthly (ClosingReport, ClosingReport2, ClosingReport3_Monthly, CloseDay)
- ✅ Cost-center-wise report (CostCenterwiseReport), target vs actual (Ro_TargetSales)
- ✅ Bikri report, stock report (ROI_STOCKREPORT), C-report, room booking report, reservation report
- ✅ Advance/custom report builder (AdvanceReport)
- ✅ Landing summaries dashboards (LandingSummaries, RestroDashboard, RODashBoard, CBMS_Dashboard)

### 10. Platform & Administration
- ✅ Runs on standard Windows Server + IIS + SQL Server (client already owns these)
- ✅ **Auto database migration on startup** — version-tracked, additive-only schema upgrades, zero manual SQL
- ✅ Database backup & restore built into the admin panel (DatabaseBackup, SageFrame.DBBackupNRestore)
- ✅ Multi-language UI & language switcher (Language, LanguageSwitcher)
- ✅ FAQ + in-app help module (RestroHelp, FAQ)
- ✅ Logo & theme control (ROLogo, Logo, LayoutManager)
- ✅ Status/maintenance page (ROStatusPage)
- ✅ Cake order sub-module (CakeOrder/CakeBilling) for bakeries attached to restaurants

---

## 💰 Value Proposition Talking Points (for the quotation meeting)

1. **"You buy it once, you own it forever."** — No per-cover, per-terminal or per-month SaaS rent. Typical cloud POS costs ₹X,XXX/month per outlet forever; RestroOrder pays for itself in months.
2. **"Internet down? Dinner service continues."** — On-prem means the floor never stops taking orders or printing KOTs.
3. **"One manager screen, ten outlets."** — Consolidated accounts across restaurant, bar, banquet; outlet-level P&L instantly.
4. **"Stop leakage."** — Cancel-reason capture, cancelled-bill report, complimentary tracking, print-count audit and drawer/vault reconciliation are anti-theft controls most cloud POS products don't offer at all.
5. **"Works on what your staff already carries."** — Responsive web + Android waiter app on any phone/tablet/terminal; no proprietary hardware lock-in.
6. **"Grows without downtime."** — Auto-migration updates mean new features deploy in minutes, not maintenance windows.
7. **"Statutory-ready bills."** — Service charge, VAT/PAN logic, fiscal-year-linked numbering, audit-grade rounding built for local compliance.

---

## 📱 Devices Supported (single responsive codebase)
Desktop cashier terminal · Touch POS monitor · Tablet on the floor · Waiter's personal smartphone · Kitchen display/printer station (driverless)

---

*Feature list compiled directly from the production source tree: 40+ RESTRO/RO* modules, OrderWebService (30 methods), RestroWebService (10 methods), plus reservation, purchase, store, drawer and reporting subsystems. Available on request: module-by-module demo script mapped to this list.*
