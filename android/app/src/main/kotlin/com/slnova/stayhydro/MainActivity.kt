package com.slnova.stayhydro

import android.media.MediaPlayer
import android.os.Bundle
import android.os.Vibrator
import android.os.VibrationEffect
import android.os.Build
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {

    // چینل کا نام وہی ہے جو فلٹر (SoundService.dart) میں استعمال ہو رہا ہے
    private val CHANNEL = "stayhydro_sound_channel"
    private var mediaPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // میتھڈ چینل کی رجسٹریشن - ہم نے binaryMessenger کو انجن سے براہ راست جوڑا ہے
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "play_sound" -> {
                        // ایپ کی ڈیفالٹ آوازیں بجانے کے لیے
                        val soundKey = call.argument<String>("sound") ?: "water_glass"
                        playSound(soundKey)
                        result.success(null)
                    }
                    "play_custom_file" -> {
                        // ڈیوائس سے سلیکٹ کی گئی کسٹم فائل بجانے کے لیے
                        val path = call.argument<String>("path")
                        if (path != null) {
                            playCustomFile(path)
                            result.success(null)
                        } else {
                            result.error("ERR_PATH", "Path is null", null)
                        }
                    }
                    "vibrate" -> {
                        // فون کو وائبریٹ کرنے کے لیے
                        triggerVibration()
                        result.success(null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    // [FUNCTION: PLAY APP SOUNDS]
    // ایپ کے اندر موجود را (raw) فائلز بجانے کے لیے
    private fun playSound(soundKey: String) {
        try {
            val soundResId = when (soundKey) {
                "soft_knock" -> R.raw.soft_knock
                "water_drop" -> R.raw.water_drop
                "water_glass" -> R.raw.water_glass
                else -> R.raw.water_glass
            }

            mediaPlayer?.stop()
            mediaPlayer?.release()
            mediaPlayer = MediaPlayer.create(this, soundResId)
            mediaPlayer?.start()
            
            // فائل پلے ہونے کے بعد میموری فارغ کرنے کے لیے
            mediaPlayer?.setOnCompletionListener { 
                it.release()
                mediaPlayer = null
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    // [FUNCTION: PLAY CUSTOM FILE]
    // موبائل میموری کے پاتھ سے فائل بجانے کے لیے
    private fun playCustomFile(path: String) {
        try {
            val file = File(path)
            if (file.exists()) {
                mediaPlayer?.stop()
                mediaPlayer?.release()
                mediaPlayer = MediaPlayer().apply {
                    setDataSource(path)
                    prepare()
                    start()
                    setOnCompletionListener { 
                        it.release()
                        mediaPlayer = null
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    // [FUNCTION: VIBRATION]
    // فون کو تھرتھرانے کی لاجک
    private fun triggerVibration() {
        val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (vibrator.hasVibrator()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                vibrator.vibrate(500)
            }
        }
    }
}