package cc.xuty.custed2

import android.content.Context
import cc.xuty.custed2.CourseReminderNotificationManager.Companion.hexString

class CourseReminderNotificationManager private constructor(private val context: Context) {
    companion object {
        fun get(context: Context): CourseReminderNotificationManager {
            return CourseReminderNotificationManager(context)
        }

        private val Long.hexString: String
            get() {
                var tmp = this
                val ret = CharArray(16)
                for (i in 0 until 16) {
                    ret[15 - i] = "0123456789ABCDEF"[(tmp and 0x0F).toInt()]
                    tmp = tmp ushr 4
                }
                return String(ret)
            }
    }

    private val preferences = context.getSharedPreferences("CourseReminderNotificationConfig", Context.MODE_PRIVATE)

    private val NextSchedule.storageKey: String get() = "lastAlerted[${courseIdentityHash().hexString}]"

    fun lastAlerted(nextSchedule: NextSchedule): Long? {
        return preferences
            .getLong(nextSchedule.storageKey, -1)
            .takeIf { it > 0 }
//            ?.let { ApproximateTime.fromEpochMillis(it) }
    }

    fun setLastAlerted(nextSchedule: NextSchedule, timeStamp: Long) {
        with(preferences.edit()) {
            putLong(nextSchedule.storageKey, timeStamp)
            apply()
        }
    }
}