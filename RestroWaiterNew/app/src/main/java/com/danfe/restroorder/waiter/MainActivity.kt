package com.danfe.restroorder.waiter

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import com.danfe.restroorder.waiter.ui.theme.RestroWaiterTheme
import com.danfe.restroorder.waiter.ui.nav.WaiterNavGraph

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            RestroWaiterTheme {
                WaiterNavGraph()
            }
        }
    }
}
