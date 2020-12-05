package cc.xuty.custed2

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.FLAG_NO_CLEAR
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : io.flutter.embedding.android.FlutterActivity() {
    companion object {
        const val SCHEDULE_NOTIFICATION_ID = 0
        const val SCHEDULE_NOTIFICATION_CHANNEL_ID = "schedule-notification"
        const val FLUTTER_NOTIFICATION_PLATFORM_CHANNEL = "custed2.xuty.cc/notification"
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            val name = "课表提醒"
            val descriptionText = "提示下节课的通知"
            val channel = NotificationChannel(
                    SCHEDULE_NOTIFICATION_CHANNEL_ID,
                    name,
                    NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = descriptionText
                if (Build.VERSION.SDK_INT >= 29) setAllowBubbles(false)
                setShowBadge(false)
                setSound(null, null)
            }
//            notificationManager.deleteNotificationChannel(SCHEDULE_NOTIFICATION_CHANNEL_ID)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun makeScheduleNotification(nextClass: String? = null) {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, intent, 0)
        val builder = NotificationCompat.Builder(this, SCHEDULE_NOTIFICATION_CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_message) // This should be reset
                .setContentTitle("下节课")
                .setContentText(nextClass?.takeUnless { it.isBlank() } ?: "无下节课")
                .setOngoing(true)
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_LOW)

        val notification = builder.build().apply {
            flags = flags or FLAG_NO_CLEAR
        }
        createNotificationChannel()
        NotificationManagerCompat.from(this).notify(SCHEDULE_NOTIFICATION_ID, notification)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FLUTTER_NOTIFICATION_PLATFORM_CHANNEL)
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "notifyNextCourse" -> {
                            val content = call.argument<String>("content")
                            if (content != null) {
                                makeScheduleNotification(content)
                            }
                        }
                        else -> result.notImplemented()
                    }
                }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        makeScheduleNotification()
    }
}