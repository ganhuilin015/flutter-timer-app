package com.gangangan.chrono

import android.app.Service
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.MediaPlayer
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.app.PendingIntent
import androidx.core.app.NotificationCompat
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.content.pm.ServiceInfo

class AlarmForegroundService : Service() {
    private var player: MediaPlayer? = null

    companion object {
        const val CHANNEL_ID = "general_channel"
        const val ACTION_STOP = "ACTION_STOP_ALARM_SERVICE"

        private const val PREFS_NAME = "alarm_state"
        private const val KEY_IS_RINGING = "is_ringing"
        private const val KEY_TYPE = "type"
        private const val KEY_ALARM_ID = "alarm_id"
        private const val KEY_NATIVE_ID = "native_id"
        private const val KEY_TITLE = "title"
        private const val KEY_BODY = "body"
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        if (intent.action == ACTION_STOP) {
            getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
                .edit()
                .clear()
                .apply()

            player?.stop()
            player?.release()
            player = null

            stopForeground(true)
            stopSelf()
            return START_STICKY
        }

        val title = intent.getStringExtra("title")
        val body = intent.getStringExtra("body")
        val soundFile = intent.getStringExtra("sound_file") ?: "alarmbuzzer.mp3"
        val notificationId = intent.getIntExtra("notification_id", 1)
        val alarmId = intent.getStringExtra("alarm_id")
        val type = intent.getStringExtra("type") ?: "alarm"

        getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
            .edit()
            .putBoolean(KEY_IS_RINGING, true)
            .putString(KEY_TYPE, type)
            .putString(KEY_ALARM_ID, alarmId)
            .putInt(KEY_NATIVE_ID, notificationId)
            .putString(KEY_TITLE, title)
            .putString(KEY_BODY, body)
            .apply()

        val openAppIntent = packageManager.getLaunchIntentForPackage(packageName)
        openAppIntent?.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP

        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            openAppIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification: Notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(body)
            .setContentIntent(pendingIntent) 
            .setAutoCancel(true)
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setOngoing(true)
            .build()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                notificationId,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
            )
        } else {
            startForeground(notificationId, notification)
        }

        val rawFileName = soundFile.removeSuffix(".mp3")
        val resId = resources.getIdentifier(
            rawFileName, "raw", packageName
        ).takeIf { it != 0 } ?: android.R.drawable.ic_media_play

        player?.release()
        player = MediaPlayer()
        val afd = resources.openRawResourceFd(resId)

        player?.apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            )

            setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
            prepareAsync()

            setOnPreparedListener {
                isLooping = true
                start()
            }
        }

        return START_NOT_STICKY  
    }

    override fun onDestroy() {
        player?.stop()
        player?.release()
        player = null
        stopForeground(true)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chan = NotificationChannel(
                CHANNEL_ID,
                "Alarms",
                NotificationManager.IMPORTANCE_HIGH
            )

            chan.setSound(null, null)
            val nm = getSystemService(NotificationManager::class.java)
            nm.createNotificationChannel(chan)
        }
    }
}