package com.slnova.stayhydro

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.MethodChannel

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent?.action ?: return

        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != Intent.ACTION_LOCKED_BOOT_COMPLETED &&
            action != Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            return
        }

        val appContext = context.applicationContext
        val flutterLoader = FlutterLoader()
        flutterLoader.startInitialization(appContext)
        flutterLoader.ensureInitializationComplete(appContext, null)

        val flutterEngine = FlutterEngine(appContext)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint(
                flutterLoader.findAppBundlePath(),
                "main"
            )
        )

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "luna_hydration_reminder/boot"
        ).invokeMethod("rescheduleNext", null)
    }
}
