package com.example.timer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.util.Log
import android.app.NotificationManager

class MainActivity : FlutterActivity() {
    private val channel = "com.example.timer/alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "scheduleAlarm" -> {
                        val id = call.argument<Int>("id")!!
                        val trigger = call.argument<Long>("trigger")!!
                        val title = call.argument<String>("title")!!
                        val body = call.argument<String>("body")!!
                        val sound = call.argument<String>("sound") ?: "alarmbuzzer.mp3"

                        scheduleAlarm(id, trigger, title, body, sound)
                        result.success(null)
                    }

                    "stopAlarm" -> {
                        val id = call.argument<Int>("id")!!
                        stopAlarmService(id)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun scheduleAlarm(
        id: Int,
        trigger: Long,
        title: String,
        body: String,
        sound: String
    ) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = Intent(this, AlarmReceiver::class.java).apply {
            putExtra("title", title)
            putExtra("body", body)
            putExtra("sound_file", sound)
            putExtra("notification_id", id)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            this,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            trigger,
            pendingIntent
        )
    }

    private fun stopAlarmService(id: Int) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val alarmIntent = Intent(this, AlarmReceiver::class.java)

        val pendingIntent = PendingIntent.getBroadcast(
            this,
            id,
            alarmIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        alarmManager.cancel(pendingIntent)
        pendingIntent.cancel()

        val stopIntent = Intent(this, AlarmForegroundService::class.java).apply {
            action = AlarmForegroundService.ACTION_STOP
            putExtra("notification_id", id)
        }

        startService(stopIntent)

        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(id)
    }
}