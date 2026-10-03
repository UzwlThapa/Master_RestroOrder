@echo off
REM ============================================================
REM  DiningApp build/publish script — run on a dev box with the
REM  .NET 8 SDK installed (Windows 10/11/Server). Produces a
REM  self-contained publish folder ready to copy to the POS server.
REM  Self-contained = the restaurant server needs NO .NET install.
REM ============================================================
setlocal
cd /d "%~dp0"

set PUBLISH_DIR=%~dp0publish\win-x64
set RUNTIME=win-x64
REM For older POS boxes still on 32-bit Windows, use: set RUNTIME=win-x86

echo [1/2] Building solution (Debug + tests)...
dotnet test DiningApp.sln -c Release --nologo -v q
if errorlevel 1 (
    echo TESTS FAILED - not publishing. Fix tests first.
    exit /b 1
)

echo [2/2] Publishing self-contained %RUNTIME% build...
dotnet publish src\DiningApp.Api\DiningApp.Api.csproj -c Release -r %RUNTIME% ^
    --self-contained true ^
    -p:PublishSingleFile=false ^
    -p:IncludeNativeLibrariesForSelfExtract=true ^
    -o "%PUBLISH_DIR%"
if errorlevel 1 exit /b 1

echo.
echo Published to %PUBLISH_DIR%
echo Next: copy that folder to C:\DiningApp on the server and run install.cmd from an elevated prompt.
endlocal
