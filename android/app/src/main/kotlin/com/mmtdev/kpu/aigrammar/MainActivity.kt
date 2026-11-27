package com.mmtdev.kpu.aigrammar

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.mmtdev.kpu.aigrammar/storage"
        ).setMethodCallHandler { call, result ->
            if (call.method == "getAppStoragePath") {
                result.success(applicationContext.filesDir.absolutePath)
            } else {
                result.notImplemented()
            }
        }
    }
}
