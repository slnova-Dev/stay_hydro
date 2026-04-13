package com.slnova.stayhydro

import android.media.MediaPlayer
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "luna_hydration_sound"
    private var mediaPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "play_sound") {
                    val soundKey = call.argument<String>("sound") ?: "water_glass"
                    playSound(soundKey)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun playSound(soundKey: String) {
        val soundResId = when (soundKey) {
            "soft_knock" -> R.raw.soft_knock
            "water_drop" -> R.raw.water_drop
            else -> R.raw.water_glass
        }

        mediaPlayer?.release()
        mediaPlayer = MediaPlayer.create(this, soundResId)
        mediaPlayer?.start()
    }
}
