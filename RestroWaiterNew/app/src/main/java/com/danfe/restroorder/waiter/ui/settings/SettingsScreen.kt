package com.danfe.restroorder.waiter.ui.settings

import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.local.FeatureFlags
import com.danfe.restroorder.waiter.ui.login.AppVMFactory

/**
 * Settings screen: server profiles (add/edit/delete/activate/test), QR scan button, LAN auto-scan,
 * and the feature switches kept from the old app. Printing options are intentionally absent —
 * printing stays on the POS server (answer #1).
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun SettingsScreen(onBack: () -> Unit) {
    val app = LocalContext.current.applicationContext as App
    val vm: SettingsViewModel = viewModel(factory = AppVMFactory(app) { SettingsViewModel(app) })
    val ui by vm.ui.collectAsState()

    Scaffold(topBar = {
        TopAppBar(
            title = { Text("Settings") },
            navigationIcon = { TextButton(onClick = onBack) { Text("← Back") } },
        )
    }) { pad ->
        Column(
            Modifier.fillMaxSize().padding(pad).verticalScroll(rememberScrollState()).padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            Text("Servers", style = MaterialTheme.typography.headlineSmall)
            ui.profiles.forEach { p ->
                ProfileCard(
                    profile = p,
                    active = p.id == ui.activeId,
                    testing = ui.testing,
                    onActivate = { vm.activate(p.id) },
                    onTest = { vm.test(p.id) },
                    onDelete = { vm.deleteProfile(p.id) },
                )
            }

            var name by rememberSaveable { mutableStateOf("") }
            var address by rememberSaveable { mutableStateOf("") }
            var https by rememberSaveable { mutableStateOf(false) }
            var prefix by rememberSaveable { mutableStateOf("/Modules") }
            var trustCert by rememberSaveable { mutableStateOf(false) }
            Card {
                Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text("Add server", style = MaterialTheme.typography.titleMedium)
                    OutlinedTextField(value = name, onValueChange = { name = it }, label = { Text("Name (e.g. Main Branch)") }, singleLine = true, modifier = Modifier.fillMaxWidth())
                    OutlinedTextField(value = address, onValueChange = { address = it }, label = { Text("IP / host[:port] e.g. 192.168.1.5:8007") }, singleLine = true, modifier = Modifier.fillMaxWidth())
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Checkbox(checked = https, onCheckedChange = { https = it })
                        Text("Use HTTPS (cloud server)")
                        Spacer(Modifier.width(16.dp))
                        Checkbox(checked = trustCert, onCheckedChange = { trustCert = it })
                        Text("Trust certificate")
                    }
                    OutlinedTextField(value = prefix, onValueChange = { prefix = it }, label = { Text("Path prefix (/Modules)") }, singleLine = true, modifier = Modifier.fillMaxWidth())
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        Button(onClick = { vm.addProfile(name, address, https, prefix, trustCert); name = ""; address = "" }) { Text("Save server") }
                        // QR scanning uses the Play Services code scanner Activity (no camera permission needed):
                        QrScanButton { text -> vm.applyScanned(text) }
                    }
                }
            }

            ui.testResult?.let { Text(it, style = MaterialTheme.typography.bodyLarge) }

            // ---- LAN auto-discovery (best effort) ----
            Card {
                Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text("Find server on this network", style = MaterialTheme.typography.titleMedium)
                    Text("Scans your Wi-Fi subnet for a RestroOrder IIS. Takes ~1 minute.", style = MaterialTheme.typography.bodySmall)
                    Button(onClick = { vm.startLanScan(listOf(8007, 80, 443), https = false) }, enabled = !ui.scanning) {
                        Text(if (ui.scanning) "Scanning…" else "Start scan")
                    }
                    ui.discovered.forEach { f ->
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text("${f.address}  ", modifier = Modifier.weight(1f))
                            TextButton(onClick = { vm.useDiscovered(f) }) { Text("Use") }
                        }
                    }
                }
            }

            // ---- feature switches (kept from old settings screen) ----
            Text("Features", style = MaterialTheme.typography.headlineSmall)
            FlagRow("Split bill", ui.flags.splitBill) { v -> vm.setFlag { it.copy(splitBill = v) } }
            FlagRow("Merge tables", ui.flags.mergeTables) { v -> vm.setFlag { it.copy(mergeTables = v) } }
            FlagRow("Unmerge tables", ui.flags.unmergeTables) { v -> vm.setFlag { it.copy(unmergeTables = v) } }
            FlagRow("Shift table", ui.flags.shiftTable) { v -> vm.setFlag { it.copy(shiftTable = v) } }
            FlagRow("Shift items", ui.flags.shiftItems) { v -> vm.setFlag { it.copy(shiftItems = v) } }
            FlagRow("Show bill", ui.flags.showBill) { v -> vm.setFlag { it.copy(showBill = v) } }
            FlagRow("Cancel order", ui.flags.cancelOrder) { v -> vm.setFlag { it.copy(cancelOrder = v) } }
            FlagRow("Out-of-stock toggle", ui.flags.outOfStockToggle) { v -> vm.setFlag { it.copy(outOfStockToggle = v) } }
            FlagRow("Pay bill", ui.flags.payBill) { v -> vm.setFlag { it.copy(payBill = v) } }

            if (ui.saved) LaunchedEffect(Unit) { vm.consumeSaved() }
        }
    }
}

@Composable
private fun ProfileCard(
    profile: com.danfe.restroorder.waiter.data.local.ServerProfile,
    active: Boolean,
    testing: Boolean,
    onActivate: () -> Unit,
    onTest: () -> Unit,
    onDelete: () -> Unit,
) {
    Card(modifier = Modifier.fillMaxWidth()) {
        Row(Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            Column(Modifier.weight(1f)) {
                Text(profile.name, style = MaterialTheme.typography.titleMedium)
                Text("${profile.scheme}://${profile.hostPort}${profile.pathPrefix}", style = MaterialTheme.typography.bodySmall)
                if (profile.trustSelfSigned) Text("trusts any certificate", style = MaterialTheme.typography.bodySmall)
            }
            if (active) AssistChip(onClick = {}, label = { Text("Active") })
            else TextButton(onClick = onActivate) { Text("Use") }
            TextButton(onClick = onTest, enabled = !testing) { Text(if (testing) "…" else "Test") }
            TextButton(onClick = onDelete) { Text("Delete", color = MaterialTheme.colorScheme.error) }
        }
    }
}

@Composable
private fun FlagRow(label: String, value: Boolean, onChange: (Boolean) -> Unit) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Checkbox(checked = value, onCheckedChange = onChange)
        Text(label)
    }
}

/**
 * QR scan via the MLKit Barcode Scanning "simple scanner" bundled in play-services-code-scanner.
 * The scanner UI runs in its own activity inside this process; no CAMERA permission is needed.
 * API: GmsBarcodeScanning.getClient(context, options) -> scanner.start() : Task<String>
 * If Play Services is missing/unavailable, the task fails and we surface a message; manual entry still works.
 */
@Composable
private fun QrScanButton(onResult: (String) -> Unit) {
    val context = LocalContext.current
    var err by remember { mutableStateOf<String?>(null) }
    OutlinedButton(onClick = {
        err = null
        try {
            val opts = com.google.mlkit.vision.codescanner.GmsBarcodeScannerOptions.Builder()
                .setBarcodeFormats(com.google.mlkit.vision.barcode.common.Barcode.FORMAT_QR_CODE)
                .build()
            val scanner = com.google.mlkit.vision.codescanner.GmsBarcodeScanning.getClient(context, opts)
            scanner.startScan()
                .addOnSuccessListener { barcode ->
                    val value = barcode.rawValue
                    if (!value.isNullOrBlank()) onResult(value) else err = "No code found"
                }
                .addOnFailureListener { err = "QR scan failed (Play Services unavailable?). Enter the address manually." }
        } catch (_: Exception) {
            err = "QR scanning needs Google Play Services. Enter the address manually."
        }
    }) { Text("Scan QR") }
    err?.let { Text(it, color = MaterialTheme.colorScheme.error) }
}
