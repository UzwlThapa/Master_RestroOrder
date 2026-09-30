package com.danfe.restroorder.waiter.ui.nav

import androidx.compose.runtime.*
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.danfe.restroorder.waiter.App
import com.danfe.restroorder.waiter.data.model.TableRow
import com.danfe.restroorder.waiter.ui.bill.ShowBillScreen
import com.danfe.restroorder.waiter.ui.log.DebugLogScreen
import com.danfe.restroorder.waiter.ui.login.LoginScreen
import com.danfe.restroorder.waiter.ui.order.OrderScreen
import com.danfe.restroorder.waiter.ui.settings.SettingsScreen
import com.danfe.restroorder.waiter.ui.shift.ShiftScreen
import com.danfe.restroorder.waiter.ui.tables.TablesScreen
import androidx.compose.ui.platform.LocalContext
import kotlinx.coroutines.launch

/**
 * Single-Activity navigation. Routes mirror the old activities:
 *  login            -> LoginActivity
 *  tables           -> TableActivity
 *  order/{id}/{om}  -> MainActivity (ordering)
 *  shift/{mode}     -> TableSelectionActivity / ItemShiftActivity
 *  bill             -> ShowBillActivity
 *  settings         -> server profiles + feature switches
 *  log              -> in-app HTTP debug log
 */
object Routes {
    const val LOGIN = "login"
    const val TABLES = "tables"
    const val SETTINGS = "settings"
    const val LOG = "log"
    const val ORDER = "order/{tableId}/{orderMasterId}/{roomId}"
    const val SHIFT = "shift/{mode}"
    const val BILL = "bill"

    fun order(tableId: String, orderMasterId: String, roomId: String?) =
        "order/${urlEncode(tableId)}/${urlEncode(orderMasterId)}/${urlEncode(roomId ?: "")}"

    private fun urlEncode(v: String) = java.net.URLEncoder.encode(v, "UTF-8")
    fun shift(mode: String) = "shift/$mode"
}

/** Cross-screen payloads that are too rich for nav args (kept in memory, single Activity). */
object NavPayload {
    var table: TableRow? = null
    /** roomId of the currently-browsed room on the tables screen, so ordering can send RoomId like the old app. */
    var currentRoomId: String? = null
}

private fun vmRoomIdOf(tableId: String): String? = NavPayload.currentRoomId

@Composable
fun WaiterNavGraph() {
    val app = LocalContext.current.applicationContext as App
    val nav = rememberNavController()
    val sessionState by app.session.state.collectAsState()
    val loggedIn = sessionState.loggedIn
    var start by remember { mutableStateOf<String?>(null) }
    LaunchedEffect(Unit) { if (start == null) start = if (app.session.state.value.loggedIn) Routes.TABLES else Routes.LOGIN }
    val s0 = start ?: return
    val scope = rememberCoroutineScope()

    // Global logout: whenever the session drops (auto-logout / Logout button), return to login.
    LaunchedEffect(s0, loggedIn) {
        if (loggedIn == false && nav.currentDestination?.route != Routes.LOGIN) {
            nav.navigate(Routes.LOGIN) { popUpTo(s0) { inclusive = true } }
        }
    }

    NavHost(navController = nav, startDestination = s0) {
        composable(Routes.LOGIN) {
            LoginScreen(
                onLoggedIn = { nav.navigate(Routes.TABLES) { popUpTo(Routes.LOGIN) { inclusive = true } } },
                onOpenSettings = { nav.navigate(Routes.SETTINGS) },
            )
        }
        composable(Routes.TABLES) {
            TablesScreen(
                onOpenTable = { tableId, om -> nav.navigate(Routes.order(tableId, om, vmRoomIdOf(tableId))) },
                onShiftTable = { t -> NavPayload.table = t; nav.navigate(Routes.shift("table")) },
                onShiftItems = { t -> NavPayload.table = t; nav.navigate(Routes.shift("items")) },
                onShowBill = { t -> NavPayload.table = t; nav.navigate(Routes.BILL) },
                onLogout = { scope.launch { app.session.forceLogout() } },
                onOpenSettings = { nav.navigate(Routes.SETTINGS) },
            )
        }
        composable(
            Routes.ORDER,
            arguments = listOf(
                navArgument("tableId") { type = NavType.StringType },
                navArgument("orderMasterId") { type = NavType.StringType },
                navArgument("roomId") { type = NavType.StringType; defaultValue = "" },
            ),
        ) { entry ->
            OrderScreen(
                tableId = entry.arguments?.getString("tableId").orEmpty(),
                orderMasterId = entry.arguments?.getString("orderMasterId").orEmpty(),
                roomId = entry.arguments?.getString("roomId").orEmpty().ifBlank { null },
                onBack = { nav.popBackStack() },
                onLogout = { scope.launch { app.session.forceLogout() } },
            )
        }
        composable(
            Routes.SHIFT,
            arguments = listOf(navArgument("mode") { type = NavType.StringType }),
        ) { entry ->
            val mode = entry.arguments?.getString("mode") ?: "table"
            val src = NavPayload.table
            if (src == null) { LaunchedEffect(Unit) { nav.popBackStack() } }
            else ShiftScreen(
                source = src,
                mode = mode,
                onBack = { nav.popBackStack() },
                requestPin = { onOk -> pinRequest.value = onOk },
            )
        }
        composable(Routes.BILL) {
            val src = NavPayload.table
            if (src == null) { LaunchedEffect(Unit) { nav.popBackStack() } }
            else ShowBillScreen(table = src, onBack = { nav.popBackStack() })
        }
        composable(Routes.SETTINGS) {
            SettingsScreen(onBack = { if (!nav.popBackStack()) nav.navigate(Routes.LOGIN) })
        }
        composable(Routes.LOG) {
            DebugLogScreen(onBack = { nav.popBackStack() })
        }
    }

    // Shared PIN prompt used by shift flows (server CheckPin still validates inside the VM).
    PinHost()
}

private val pinRequest = mutableStateOf<((String) -> Unit)?>(null)

@Composable
private fun PinHost() {
    val pending = pinRequest.value ?: return
    com.danfe.restroorder.waiter.ui.common.PinDialog(
        title = "Enter PIN",
        onDismiss = { pinRequest.value = null },
        onSubmit = { pin -> pinRequest.value = null; pending(pin) },
    )
}
