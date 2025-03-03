package com.example.mask

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.mask/hide_app"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "hideApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        hideApp(packageName)
                        result.success("App ocultado")
                    } else {
                        result.error("ERROR", "Pacote inválido", null)
                    }
                }
                "showApp" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        showApp(packageName)
                        result.success("App restaurado")
                    } else {
                        result.error("ERROR", "Pacote inválido", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun hideApp(packageName: String) {
        val packageManager = applicationContext.packageManager
        val componentName = ComponentName(applicationContext, packageName)
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }

    private fun showApp(packageName: String) {
        val packageManager = applicationContext.packageManager
        val componentName = ComponentName(applicationContext, packageName)
        packageManager.setComponentEnabledSetting(
            componentName,
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
    }
}
