package com.gangangan.chrono

import android.app.NotificationManager
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {

        val serviceIntent = Intent(
            context,
            AlarmForegroundService::class.java
        ).apply {
            putExtra(
                "title",
                intent.getStringExtra("title")
            )

            putExtra(
                "body",
                intent.getStringExtra("body")
            )

            putExtra(
                "sound_file",
                intent.getStringExtra("sound_file")
            )

            putExtra(
                "notification_id",
                intent.getIntExtra("notification_id", -1)
            )

            putExtra(
                "alarm_id",
                intent.getStringExtra("alarm_id")
            )

            putExtra(
                "type",
                intent.getStringExtra("type")
            )
        }

        ContextCompat.startForegroundService(context,serviceIntent)
    }
}