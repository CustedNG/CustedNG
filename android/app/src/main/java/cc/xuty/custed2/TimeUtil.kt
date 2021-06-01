package cc.xuty.custed2

import java.text.SimpleDateFormat
import java.time.LocalDate
import java.time.ZoneId
import java.util.*

data class ApproximateTime(
    val hour: Int,
    val minute: Int
) {
    companion object {
        private val chinaTimeZone = TimeZone.getTimeZone("GMT+8:00")

        fun parseOrNull(str: String): ApproximateTime? {
            val split = str.split(':')
            val hour = split.getOrNull(0)?.toIntOrNull()
            val minute = split.getOrNull(1)?.toIntOrNull()
            if (hour == null || minute == null) return null
            return ApproximateTime(hour, minute)
        }

        fun fromCalendar(calendar: Calendar): ApproximateTime {
            val hour = calendar.get(Calendar.HOUR_OF_DAY)
            val minute = calendar.get(Calendar.MINUTE)
            return ApproximateTime(hour, minute)
        }

        fun now(): ApproximateTime {
            return fromCalendar(GregorianCalendar(chinaTimeZone))
        }

        fun fromEpochMillis(epochMillis: Long): ApproximateTime {
            val calendar = GregorianCalendar(chinaTimeZone)
            calendar.timeInMillis = epochMillis
            return fromCalendar(calendar)
        }
    }

    fun toMinutes(): Int {
        return hour * 60 + minute
    }

    operator fun compareTo(target: ApproximateTime): Int {
        if (hour != target.hour) return hour.compareTo(target.hour)
        return minute.compareTo(target.minute)
    }

    fun forwardDifferenceToInMinutes(target: ApproximateTime): Int {
        val minutesADay = 24 * 60
        return (target.toMinutes() - toMinutes() + minutesADay) % minutesADay
    }

    fun relativeDifferenceToInMinutes(target: ApproximateTime): Int {
        return toMinutes() - target.toMinutes()
    }
}

object TimeUtil {
    object ConvertToMillis {
        val Int.seconds get() = this * (1000)
        val Int.minutes get() = this * (1000 * 60)
        val Int.hours get() = this * (1000 * 60 * 60)
        val Int.days get() = this * (1000 * 60 * 60 * 24)
    }

    fun toUserFriendlyTimeString(timestamp:Long): String {
        return SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date(timestamp))
    }

    fun dateString(date: Date = Date()): String {
        return SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(date)
    }

    fun dateTimeString(date: Date = Date()):String{
        return SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.getDefault()).format(date)
    }
}