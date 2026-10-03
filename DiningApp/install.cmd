@echo off
REM ============================================================
REM  DiningApp installer — run ONCE from an ELEVATED command
REM  prompt on the POS server (Windows 10/11/Server 2016+).
REM  Steps: config check -> firewall rule -> Windows service -> start.
REM  Requires sc.exe (built into all supported Windows versions).
REM ============================================================
setlocal
cd /d "%~dp0"

set SERVICE_NAME=DiningApp
set DISPLAY_NAME=Dining Module API (RestroOrder)
set EXE=%~dp0DiningApp.Api.exe
set PORT=8007

REM --- must be admin (sc create + netsh advfirewall need elevation) ---
net session >nul 2>&1
if errorlevel 1 (
    echo ERROR: Run this script as Administrator. Right-click ^> Run as administrator.
    exit /b 1
)

if not exist "%EXE%" (
    echo ERROR: %EXE% not found. Copy the publish folder contents here first ^(build-publish.cmd output^).
    exit /b 1
)

REM --- config sanity: refuse to start without appsettings.json (secrets stay out of git) ---
if not exist "%~dp0appsettings.json" (
    echo appsettings.json is missing. Creating it from appsettings.example.json...
    if not exist "%~dp0appsettings.example.json" (
        echo ERROR: appsettings.example.json also missing - broken deployment folder.
        exit /b 1
    )
    copy "%~dp0appsettings.example.json" "%~dp0appsettings.json" >nul
    echo.
    echo >>> EDIT C:\DiningApp\appsettings.json NOW ^(SQL connection string!^) <<<
    echo Continuing after you save and close Notepad...
    notepad "%~dp0appsettings.json"
)

REM --- idempotent install: drop any previous service ---
sc query %SERVICE_NAME% >nul 2>&1
if not errorlevel 1 (
    echo Stopping/removing existing %SERVICE_NAME% service...
    net stop %SERVICE_NAME% >nul 2>&1
    sc delete %SERVICE_NAME% >nul 2>&1
    REM give the SCM time to finish deletion before re-creating
    ping -n 4 127.0.0.1 >nul
)

echo Creating Windows service %SERVICE_NAME% (auto-start)...
REM LocalSystem works when SQL uses Windows auth with the machine account; switch to
REM obj= ".\DomainUser" (and grant it SQL access) if you use a domain service account.
sc create %SERVICE_NAME% binPath= "\"%EXE%\"" start= auto DisplayName= "%DISPLAY_NAME%"
if errorlevel 1 exit /b 1

REM Restart automatically once if it ever crashes (old IIS app-pool behavior parity)
sc failure %SERVICE_NAME% reset= 86400 actions= restart/5000/restart/10000/restart/30000
REM 5s grace so Serilog flushes and the print spooler thread can finish writing KOTs
sc timeout %SERVICE_NAME% /timeout: 5000 >nul 2>&1

echo Opening firewall port %PORT%/tcp for waiter tablets (LocalSubnet only)...
netsh advfirewall firewall delete rule name="DiningApp-WaiterAPI" >nul 2>&1
netsh advfirewall firewall add rule name="DiningApp-WaiterAPI" dir=in action=allow protocol=TCP localport=%PORT% remoteip=localsubnet profile=private,domain
if errorlevel 1 (
    echo WARNING: firewall rule failed. Add inbound TCP %PORT% manually before using tablets.
)

echo Starting service...
net start %SERVICE_NAME%
if errorlevel 1 (
    echo ERROR: service failed to start. Check logs at %~dp0logs\ and run "%EXE%" in a console for details.
    exit /b 1
)

echo.
echo DONE. Waiter base URL: http://THIS-MACHINE-NAME:%PORT%/api
echo Logs: %~dp0logs\diningapp-.log  ^(rolling, safe to leave running 24/7^)
endlocal
