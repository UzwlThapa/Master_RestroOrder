package com.danfe.restroorder.waiter.data.api

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/** Keeps the last 400 lines of OkHttp logging for the in-app debug screen. */
class HttpLogRingBuffer(private val capacity: Int = 400) {
    private val deque = ArrayDeque<String>()
    private val timeFmt = SimpleDateFormat("HH:mm:ss", Locale.US)
    private val _flow = MutableStateFlow<List<String>>(emptyList())
    val flow: StateFlow<List<String>> = _flow

    fun append(line: String) {
        synchronized(deque) {
            deque.addLast("${timeFmt.format(Date())} $line")
            while (deque.size > capacity) deque.removeFirst()
            _flow.value = deque.toList()
        }
    }

    fun clear() {
        synchronized(deque) {
            deque.clear()
            _flow.value = emptyList()
        }
    }
}
