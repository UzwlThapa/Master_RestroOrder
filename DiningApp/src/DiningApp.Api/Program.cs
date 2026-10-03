// DiningApp — on-prem replacement for the legacy SageFrame ASMX dining endpoints.
//
// URL parity (RestroWaiter app + old web UI call these paths):
//   GET/POST /Modules/ROUSER/ROLoginWebService.asmx/<Method>
//   GET/POST /Modules/ROPurchaseOrder/ROPurchaseOrderWebService.asmx/<Method>
//   ...mapped via LegacyPaths below (single source of truth, shared with contract tests).
//
// Behavior: AsmxInvoker binds parameters exactly like System.Web.Services (case-insensitive,
// lenient coercion), runs the verbatim-ported service method, and writes its Context.Response
// output back with 200 — byte-parity with IIS+ASMX, including the loose `{statusCode:200,...}`
// envelopes clients already parse.
//
// Hosting: console (dev) or Windows Service (--run-as-service / launched by SCM). Listens on
// http://+:<port> so LAN devices reach it; install.cmd adds the Windows Firewall rule.
#pragma warning disable
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;
using ILogger = Microsoft.Extensions.Logging.ILogger;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(new WebApplicationOptions {
    Args = args,
    // appsettings.json lives next to the exe even when launched as a service from another cwd
    ContentRootPath = AppContext.BaseDirectory
});

builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
builder.Configuration.AddEnvironmentVariables(prefix: "DINING_");

// ---- config validation: fail fast at startup, not mid-request ------------------------------------
var csFromEnv = Environment.GetEnvironmentVariable("DINING_CONNECTIONSTRING");
var cs = !string.IsNullOrEmpty(csFromEnv) ? csFromEnv : builder.Configuration["ConnectionStrings:LocalSqlServer"];
if (string.IsNullOrWhiteSpace(cs))
    throw new InvalidOperationException(
        "No connection string configured. Set ConnectionStrings:LocalSqlServer in appsettings.json " +
        "or the DINING_CONNECTIONSTRING environment variable. See docs/deployment.md.");

// ---- Kestrel: LAN binding, slow-network friendly ---------------------------------------------------
var port = builder.Configuration.GetValue<int?>("Dining:Port") ?? 8007;
builder.WebHost.ConfigureKestrel(k => {
    k.ListenAnyIP(port);                                  // reachable from waiter tablets on the LAN
    k.Limits.MaxRequestBodySize = 10 * 1024 * 1024;       // sane cap; menus/posted JSON are small
    k.Limits.KeepAliveTimeout = TimeSpan.FromMinutes(2);  // flaky Wi-Fi reconnects reuse connections
    k.Limits.RequestHeadersTimeout = TimeSpan.FromSeconds(30); // slow POST bodies still land
    k.Limits.MaxConcurrentConnections = 200;              // tablet fleet guard-rail
});

// ---- Windows service hosting ------------------------------------------------------------------------
bool runAsService = args.Contains("--run-as-service")
    || Environment.GetEnvironmentVariable("DINING_RUN_AS_SERVICE") == "1";
if (runAsService && OperatingSystem.IsWindows())
    builder.Services.AddWindowsService(o => o.ServiceName = "DiningApp");

// ---- logging: Serilog rolling file next to the exe (SCM has no console) + console -------------------
// PROD-BUGFIX: the built-in logger needs a provider for AddLogging; previously no log sink was ever
// registered, so a Windows Service silently lost all diagnostics. Serilog writes daily rolling files
// under <exe>/logs with size caps and retention so an on-prem box can't fill its disk.
builder.Host.UseSerilog((hosting, lc) => lc
    .ReadFrom.Configuration(hosting.Configuration)
    .Enrich.FromLogContext()
    .WriteTo.Console(outputTemplate: "{Timestamp:yyyy-MM-dd HH:mm:ss.fff} [{Level:u3}] {Message:lj}{NewLine}{Exception}")
    .WriteTo.File(
        Path.Combine(AppContext.BaseDirectory, "logs", "diningapp-.log"),
        rollingInterval: RollingInterval.Day,
        retainedFileCountLimit: 14,
        rollOnFileSizeLimit: true,
        fileSizeLimitBytes: 20_000_000,
        shared: true,                      // don't lock the file when ops tail it while the service runs
        flushToDiskInterval: TimeSpan.FromSeconds(2)));
builder.Logging.ClearProviders();          // console output comes from Serilog, not double-sunk

// ---- production seams (legacy shims default to no-op; wire the real ones here) -----------------------
builder.Services.AddSingleton<IWaiterNotifier, DiningApp.Api.UdpWaiterNotifier>();
builder.Services.AddSingleton<DiningApp.Api.PrintingHostService>();
builder.Services.AddHostedService(sp => sp.GetRequiredService<DiningApp.Api.PrintingHostService>());

var app = builder.Build();

// PrinterBackend seam: route all legacy Printer.* calls through the queue-backed host service so a
// dead/offline receipt printer never fails an order request (jobs retry until the printer returns).
PrinterBackend.Current = app.Services.GetRequiredService<DiningApp.Api.PrintingHostService>();

// Waiter-call bell seam (same posture: background, never fails a request).
WaiterNotification.Current = app.Services.GetRequiredService<IWaiterNotifier>();

// ---- health probes -----------------------------------------------------------------------------------
app.MapGet("/health", () => Results.Ok(new { status = "ok", time = DateTime.Now }));
app.MapGet("/health/db", (ILoggerFactory lf) => {
    try {
        using var sql = new Microsoft.Data.SqlClient.SqlConnection(cs);
        sql.Open();
        using var cmd = sql.CreateCommand();
        cmd.CommandText = "select 1";
        cmd.ExecuteScalar();
        return Results.Ok(new { status = "ok" });
    } catch (Exception ex) {
        lf.CreateLogger("health").LogError(ex, "DB health check failed");
        return Results.Json(new { status = "down", error = ex.Message }, statusCode: 503);
    }
});

// ---- ASMX-parity endpoint mapping ---------------------------------------------------------------------
var services = DiscoverServices();
MapLegacyEndpoints(app, services, app.Logger);

app.Logger.LogInformation("DiningApp ready: port {Port}, {Count} services ({Svc}).",
    port, services.Count, string.Join(", ", services.Keys.Select(t => LegacyPaths.PathOf(t.Name))));

app.Run();

// ======================================================================================================
static Dictionary<Type, object> DiscoverServices() {
    // Ported .asmx classes live in the GLOBAL namespace of the compiled Api assembly.
    var asm = typeof(RoLoginWebService).Assembly;
    var map = new Dictionary<Type, object>();
    foreach (var t in asm.GetTypes()) {
        if (t.IsAbstract || t.Namespace != null) continue;             // global namespace only
        if (!typeof(System.Web.Services.WebService).IsAssignableFrom(t)) continue;
        if (!t.Name.EndsWith("WebService", StringComparison.Ordinal)) continue;
        map[t] = Activator.CreateInstance(t); // parameterless ctors; stateless per legacy contract
    }
    if (map.Count == 0) throw new InvalidOperationException("No ported WebService types found — build broken?");
    return map;
}

static void MapLegacyEndpoints(WebApplication app, Dictionary<Type, object> services, ILogger log) {
    foreach (var kv in services) {
        var type = kv.Key;
        var instance = kv.Value;
        string typeName = type.Name;
        if (!LegacyPaths.TryGet(typeName, out var basePath)) {
            log.LogWarning("No legacy URL mapping for {Type}; skipping.", typeName);
            continue;
        }
        var methods = type.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly)
                          .Where(m => m.GetCustomAttributes(typeof(System.Web.Services.WebMethodAttribute), true).Length > 0)
                          .ToList();
        foreach (var m in methods) {
            // One URL per method. Accept BOTH verbs: the waiter app posts JSON bodies, the old web UI
            // issues GETs with query params; legacy ASMX tolerated both shapes.
            string pattern = basePath.TrimEnd('/') + "/" + m.Name;
            app.Map(pattern, async ctx => {
                var started = DateTime.UtcNow;
                try {
                    // InvokeAsync handles fault writing (504/500 JSON) internally and returns false
                    // when it did; we only log here. Exceptions escaping the fault writer itself are
                    // caught by the outer ASP.NET Core handler.
                    bool ok = await DiningApp.Api.AsmxInvoker.InvokeAsync(instance, m.Name, ctx);
                    if (!ok) log.LogWarning("Fault response for {Pattern}", pattern);
                } finally {
                    var ms = (DateTime.UtcNow - started).TotalMilliseconds;
                    if (ms > 5000) log.LogWarning("SLOW request {Pattern}: {Ms:F0}ms", pattern, ms);
                }
            });
        }
        log.LogInformation("Mapped {Base}/* -> {Type} ({N} methods)", basePath, typeName, methods.Count);
    }
}

static async Task WriteFaultAsync(Microsoft.AspNetCore.Http.HttpContext ctx, int status, string message) {
    ctx.Response.StatusCode = status;
    ctx.Response.ContentType = "application/json; charset=utf-8";
    var esc = message.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " ");
    await ctx.Response.WriteAsync("{\"statusCode\":" + status + ",\"message\":\"" + esc + "\",\"data\":null}");
}

/// <summary>Legacy ASMX virtual paths -> ported service class names (shared with contract tests).</summary>
public static class LegacyPaths {
    static readonly Dictionary<string, string> Map = new(StringComparer.OrdinalIgnoreCase) {
        { "RoLoginWebService",           "/Modules/ROUSER/ROLoginWebService.asmx" },
        { "RoPurchaseOrderWebService",   "/Modules/ROPurchaseOrder/ROPurchaseOrderWebService.asmx" },
        { "OrderWebService",             "/Modules/RestoOrder/OrderWebService.asmx" },
        { "DashBoardWebService",         "/Modules/RestoOrder/DashBoardWebService.asmx" },
        { "RestroWebService",            "/Modules/RestoOrder/RestroWebService.asmx" },
    };
    public static bool TryGet(string serviceName, out string path) => Map.TryGetValue(serviceName, out path);
    public static string PathOf(string serviceName) => Map.TryGetValue(serviceName, out var p) ? p : serviceName;
    public static IEnumerable<KeyValuePair<string, string>> All => Map;
}
