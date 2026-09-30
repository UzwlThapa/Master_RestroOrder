# On-Premise Windows IIS & SSMS Integration Guide

This guide ensures your existing Windows Server hosting **SageFrame / RestroOrder** connects seamlessly to the Android Waiter APK.

---

## 1. Windows Firewall (Crucial Step)
Open PowerShell as Administrator on the Windows host and execute:
```powershell
New-NetFirewallRule -DisplayName "IIS RestroOrder Waiter LAN" -Direction Inbound -LocalPort 80,443,8080,8443 -Protocol TCP -Action Allow -Profile Private,Domain
```

---

## 2. IIS web.config Settings
1. Open `web.config` in your `SageFrame` web root.
2. Under `<system.web>`, extend the session timeout to 120 minutes:
```xml
<sessionState mode="InProc" timeout="120" cookieless="false" />
```
3. Verify your SQL Server connection string (managed via SSMS):
```xml
<!-- In LAN deployments without domain TLS certificates for SQL Server, ensure TrustServerCertificate is True: -->
<add name="SageFrameConnectionString" connectionString="...;Encrypt=True;TrustServerCertificate=True;" />
```

---

## 3. Finding Your Dining Page ID
1. Open your browser on the server: `http://localhost/Default.aspx`
2. Navigate to the Dining / Table Layout module.
3. Look at the URL in the address bar: `.../Default.aspx?id=42`
4. The number (e.g. **42**) is your Dining Page ID. Enter this in the app's server configuration.

---

## 4. Deploying WaiterBridge.asmx (Optional Helper)
Copy `SageFrame/App_WebServices/WaiterBridge.asmx` into your `SageFrame/App_WebServices/` folder.
This enables per-waiter printer registration and server health ping.

---

## 5. SQL Server Database (SSMS) Verification
No tables or stored procedures need alteration. The APK calls the existing `DashBoardWebService.asmx` methods (`SaveSalesBill`, `GetUnpaidBills`, etc.), which write directly to your SQL Server database.
