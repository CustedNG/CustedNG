package cc.xuty.custed2

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

class CourseReminderNotificationBuilder(private val ctx: Context) {
    companion object {
        private const val emptyString = ""
        const val COURSE_REMINDER_CHANNEL_ID = "CustedNotification.CourseReminder"

        var notificationId: Int = 10000
            private set

        val allocateNewId: Int get() = notificationId++
    }

    val notificationId = allocateNewId


    private var title = emptyString
    private var contentText = emptyString

    private var builderOptions: (NotificationCompat.Builder.() -> Unit)? = null

    fun withNextSchedule(nextSchedule: NextSchedule) = apply {
        with(nextSchedule) {
            title = "下节课 $startTime - $courseName"
            contentText = "位于 $position"
        }
    }

    fun applyOnBuilder(block: NotificationCompat.Builder.() -> Unit) = apply {
        builderOptions = block
    }

    fun makeNativeBuilder(): NotificationCompat.Builder {
        createNotificationChannel()
        return NotificationCompat.Builder(ctx, COURSE_REMINDER_CHANNEL_ID)
            .setSmallIcon(R.drawable.outline_event_available_24)
            .setContentTitle(title)
            .setContentText(contentText)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setOnlyAlertOnce(true)
            .apply { builderOptions?.let { it() } }
    }

    fun build(): Notification {
        return makeNativeBuilder().build()
    }

    fun buildAndNotify(): Notification {
        val notification = build()
        NotificationManagerCompat.from(ctx)
            .notify(notificationId, notification)
        return notification
    }

    //    val notificationBuilder = NotificationCompat.Builder(ctx, "")

    private fun createNotificationChannel() {
        // Create the NotificationChannel, but only on API 26+ because
        // the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "Custed 上课提醒"
            val descriptionText = "推送上课提醒通知"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(COURSE_REMINDER_CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            // Register the channel with the system
            val notificationManager: NotificationManager =
                ctx.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}