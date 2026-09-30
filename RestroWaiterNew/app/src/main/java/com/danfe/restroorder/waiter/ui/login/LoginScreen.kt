package com.danfe.restroorder.waiter.ui.login

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.util.AutoLogout
import kotlinx.coroutines.delay

/**
 * Login screen: 4-digit PIN pad (auto-submits at 4 digits, like the old app) with a fallback
 * username/password form. Server profile chips let waiters switch servers without leaving login.
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen(onLoggedIn: () -> Unit, onOpenSettings: () -> Unit) {
    val app = LocalContext.current.applicationContext as App
    val vm: LoginViewModel = viewModel(factory = AppVMFactory(app) { LoginViewModel(app) })
    val ui by vm.ui.collectAsState()
    val state = rememberSaveable { mutableStateOf("") } // PIN buffer survives rotation

    AutoLogout.touch()

    LaunchedEffect(ui.success) { if (ui.success) onLoggedIn() }

    Scaffold(topBar = {
        TopAppBar(
            title = { Text("RestroOrder Waiter") },
            actions = {
                TextButton(onClick = onOpenSettings) { Text("Server settings") }
            }
        )
    }) { pad ->
        Column(
            modifier = Modifier.fillMaxSize().padding(pad).padding(horizontal = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
        ) {
            // ---- server profile chips (one-tap switching, answer #4 of requirements) ----
            if (ui.profiles.isNotEmpty()) {
                LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    items(ui.profiles) { p ->
                        val active = p.id == ui.activeProfile?.id
                        FilterChip(
                            selected = active,
                            onClick = { vm.selectProfile(p) },
                            label = { Text("${p.name} (${p.hostPort})") },
                        )
                    }
                }
                Spacer(Modifier.height(16.dp))
            } else {
                Card(Modifier.fillMaxWidth()) {
                    Column(Modifier.padding(16.dp)) {
                        Text("No server configured yet.")
                        Spacer(Modifier.height(8.dp))
                        Button(onClick = onOpenSettings) { Text("Add server") }
                    }
                }
                Spacer(Modifier.height(16.dp))
            }

            // ---- PIN pad ----
            Text("Enter waiter PIN", style = MaterialTheme.typography.titleLarge)
            Spacer(Modifier.height(8.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                repeat(4) { i ->
                Surface(
                        shape = MaterialTheme.shapes.medium,
                        tonalElevation = 3.dp,
                        modifier = Modifier.size(56.dp),
                    ) {
                        Box(contentAlignment = Alignment.Center) {
                            Text(if (i < state.value.length) "•" else "", style = MaterialTheme.typography.headlineMedium)
                        }
                    }
                }
            }
            Spacer(Modifier.height(16.dp))
            PinPad(
                onDigit = { d ->
                    if (state.value.length < 4) state.value += d
                },
                onBack = { if (state.value.isNotEmpty()) state.value = state.value.dropLast(1) },
                onClear = { state.value = "" },
            )

            // auto-submit at 4 digits, exactly like LoginActivity
            LaunchedEffect(state.value) {
                if (state.value.length == 4 && !ui.busy) {
                    delay(150)
                    vm.loginPin(state.value)
                    state.value = ""
                }
            }

            ui.error?.let {
                Text(it, color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(top = 12.dp))
            }
            if (ui.busy) LinearProgressIndicator(Modifier.fillMaxWidth().padding(top = 8.dp))

            HorizontalDivider(Modifier.fillMaxWidth().padding(vertical = 20.dp))

            // ---- username / password fallback ----
            var u by rememberSaveable { mutableStateOf("") }
            var pw by rememberSaveable { mutableStateOf("") }
            OutlinedTextField(value = u, onValueChange = { u = it }, label = { Text("Username") }, singleLine = true, modifier = Modifier.fillMaxWidth())
            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = pw, onValueChange = { pw = it }, label = { Text("Password") },
                visualTransformation = PasswordVisualTransformation(),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                singleLine = true, modifier = Modifier.fillMaxWidth(),
            )
            Spacer(Modifier.height(8.dp))
            Button(
                onClick = { vm.loginPassword(u, pw) },
                enabled = !ui.busy && u.isNotBlank(),
                modifier = Modifier.fillMaxWidth().height(52.dp),
            ) { Text("Log in with password") }
        }
    }

    if (ui.alreadyLoggedInElsewhere) {
        AlertDialog(
            onDismissRequest = { vm.dismissAlreadyLoggedIn() },
            title = { Text("Already logged in") },
            text = { Text("This user is logged in on another device. Log out there first, or ask an admin.") },
            confirmButton = { TextButton(onClick = { vm.dismissAlreadyLoggedIn() }) { Text("OK") } },
        )
    }
}

@Composable
private fun PinPad(onDigit: (String) -> Unit, onBack: () -> Unit, onClear: () -> Unit) {
    val keys = listOf("1", "2", "3", "4", "5", "6", "7", "8", "9", "CLR", "0", "<")
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        keys.chunked(3).forEach { row ->
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                row.forEach { k ->
                    Button(
                        onClick = {
                            when (k) {
                                "CLR" -> onClear()
                                "<" -> onBack()
                                else -> onDigit(k)
                            }
                        },
                        modifier = Modifier.size(width = 96.dp, height = 64.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.surfaceVariant, contentColor = MaterialTheme.colorScheme.onSurface),
                    ) { Text(k, style = MaterialTheme.typography.headlineSmall) }
                }
            }
        }
    }
}

/** Minimal factory so ViewModels can receive the Application. */
class AppVMFactory(private val app: App, private val create: () -> androidx.lifecycle.ViewModel) :
    androidx.lifecycle.ViewModelProvider.Factory {
    override fun <T : androidx.lifecycle.ViewModel> create(modelClass: Class<T>): T {
        @Suppress("UNCHECKED_CAST")
        return create() as T
    }
}
