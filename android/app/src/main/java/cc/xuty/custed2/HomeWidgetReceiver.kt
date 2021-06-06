package cc.xuty.custed2

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class HomeWidgetReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.BOOT_COMPLETED") {
            val alarmMgr: AlarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val alarmIntent: PendingIntent = Intent(context, HomeWidgetProvider::class.java).let { intentUpdate ->
                intentUpdate.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                PendingIntent.getBroadcast(context, 0, intentUpdate, 0)
            }
            alarmMgr.setRepeating(
                    AlarmManager.RTC,
                    System.currentTimeMillis(),
                    1000,
                    alarmIntent
            )
        }
    }
}
