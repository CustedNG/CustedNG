package cc.xuty.custed2

import android.app.Service
import android.content.Intent
import android.os.IBinder
import java.util.*

class WidgetService : Service() {
    private var mTimer: Timer? = null
    private var mTimerTask: TimerTask? = null
    override fun onCreate() {
        super.onCreate()

        mTimer = Timer()
        mTimerTask = object : TimerTask() {
            override fun run() {
                val updateIntent = Intent("cc.xuty.custed2.UPDATE_WIDGET")
                sendBroadcast(updateIntent)
            }
        }
        mTimer!!.schedule(mTimerTask, 60000, 300000)
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        mTimerTask!!.cancel()
        mTimer!!.cancel()
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        return START_STICKY
    }
}