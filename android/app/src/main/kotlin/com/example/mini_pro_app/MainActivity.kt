package com.example.mini_pro_app

import android.content.Context
import android.net.wifi.WifiManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "multicast_lock"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "acquire") {
                try {
                    val wifi = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                    val lock = wifi.createMulticastLock("flutter-mdns")
                    lock.setReferenceCounted(true)
                    lock.acquire()
                    result.success("Multicast lock acquired")
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Multicast lock failed: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
