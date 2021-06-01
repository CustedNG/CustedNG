package cc.xuty.custed2

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import cc.xuty.custed2.TimeUtil.toUserFriendlyTimeString
import com.fasterxml.jackson.annotation.JsonProperty
import es.antonborri.home_widget.HomeWidgetProvider
import okhttp3.Request
import java.io.File
import java.io.FileWriter
import java.io.IOException
import java.io.PrintWriter
import java.util.concurrent.Future
import java.text.SimpleDateFormat
import java.util.*

@Suppress("ArrayInDataClass")
data class NextSchedule(
    @JsonProperty("Name")
    var courseName: String,

    @JsonProperty("Position")
    var position: String,

    @JsonProperty("Teacher")
    var teacherName: String,

    @JsonProperty("StartTime")
    var startTime: String,

    @JsonProperty("Weeks")
    var weeks: IntArray


) {
    fun courseIdentityHash(): Long {
        var result = courseName.hashCode().toLong()
        result = 31 * result + position.hashCode()
        result = 31 * result + teacherName.hashCode()
        result = 31 * result + startTime.hashCode()
        return result
    }
}

private data class NextScheduleFetchResult(
    val successful: Boolean,
    val cancelled: Boolean,
    val result: String? = null,
    val failureReason: String? = null
)

class HomeWidgetProvider : HomeWidgetProvider() {
    private var previousTask: Future<*>? = null

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
//        Toast.makeText(context, "Updating home widget", Toast.LENGTH_SHORT).show()
        previousTask?.cancel(true)

        val eCardId = widgetData.getString("ecardId", "")
//        val eCardId = "2019003373"

        previousTask =
            Shared.executor.submit {
                NextLessonUpdate(eCardId, context, appWidgetManager, appWidgetIds).updateNextLesson()
            }
    }
}

private class NextLessonUpdate(
    private val eCardIdSupplied: String?,
    private val context: Context,
    private val appWidgetManager: AppWidgetManager,
    private val appWidgetIds: IntArray,
) {
    companion object {
        private fun String?.parseNextScheduleJson(): NextSchedule {
            return if (this == null) NextSchedule(
                "-",
                "获取失败",
                "",
                "",
                IntArray(0)
            ) else Shared.objectMapper.readValue(this, NextSchedule::class.java)
        }
    }

    private val sharedPreferences = context.getSharedPreferences("home_widget_config", Context.MODE_PRIVATE)

    private fun RemoteViews.setTextViewTextUnlessNull(resId: Int, content: String?) {
        if (content != null) {
            setTextViewText(resId, content)
        }
    }

    private val eCardIdOrCached: String?
        get() = eCardIdSupplied ?: sharedPreferences.getString("cachedECardId", null)

    private var savedLastSuccessfulUpdate: Long
        get() = sharedPreferences.getLong("lastSuccessfulUpdate", -1)
        set(value) {
            sharedPreferences.edit().putLong("lastSuccessfulUpdate", value).apply()
        }

    private var savedLessonInfoResponse: String?
        get() = sharedPreferences.getString("savedLessonInfoResponse", null)
        set(value) {
            sharedPreferences.edit().putString("savedLessonInfoResponse", value).apply()
        }

    private fun composeUrlString(eCardId: String?): String? {
        return eCardId
            ?.takeUnless { it.isBlank() }
            ?.let { "https://custed.lolli.tech/schedule/next/$it" }
    }

    fun updateNextLesson() {
        try {
            val urlString = composeUrlString(eCardIdOrCached)
            if (urlString == null) {
                updateTexts(
                    "未登录",
                    "请先登录",
                    "并刷新一次课表",
                    "",
                    "更新于 ${toUserFriendlyTimeString(System.currentTimeMillis())}"
                )
                return
            }

            val result = fetchNextLessonBlocking(urlString)

            val currentTimeStamp = System.currentTimeMillis()
            val currentTimeString = toUserFriendlyTimeString(currentTimeStamp)
            val lastSuccessfulUpdate = savedLastSuccessfulUpdate

            val resultWithFallback = if (result.successful) result.result!! else savedLessonInfoResponse

            val texts: List<String> = when (resultWithFallback) {
                null -> {
                    "更新失败|尝试Custed内|刷新课表后|重新添加该小部件".split('|')
                }
                "today have no more lesson" -> {
                    "今天|没有课了|放松一下吧|(｡ì _ í｡)".split('|')
                }
                else -> {
                    val nxtCourse = resultWithFallback.parseNextScheduleJson()
                    val manager = CourseReminderNotificationManager.get(context)

                    if (shouldNotify(manager, nxtCourse)) {
                        CourseReminderNotificationBuilder(context)
                            .withNextSchedule(nxtCourse)
                            .buildAndNotify()
                        manager.setLastAlerted(nxtCourse, System.currentTimeMillis())
                    }

                    listOf(
                        nxtCourse.startTime,
                        nxtCourse.courseName,
                        nxtCourse.position,
                        nxtCourse.teacherName,
                    )
                }
            }
            if (result.successful) {
                savedLastSuccessfulUpdate = currentTimeStamp
                savedLessonInfoResponse = result.result
            }
            val updateTimeString =
                if (result.successful) "更新于 $currentTimeString"
                else "更新于 ${toUserFriendlyTimeString(lastSuccessfulUpdate)} (上次失败: $currentTimeString)"
            updateTexts(
                texts[0],
                texts[1],
                texts[2],
                texts[3],
                updateTimeString
            )
        } catch (e: Throwable) {
            e.printStackTrace()
            logException(e)
            throw e
        }
    }


    private fun shouldNotify(manager: CourseReminderNotificationManager, schedule: NextSchedule): Boolean {
        val startTime = ApproximateTime.parseOrNull(schedule.startTime)
        if (startTime != null) {
            val timeToStart = startTime.relativeDifferenceToInMinutes(ApproximateTime.now())
            if (timeToStart > 35 || timeToStart < -20) return false
        }
        with(TimeUtil.ConvertToMillis) {
            val lastNotification = manager.lastAlerted(schedule) ?: return true
            if (System.currentTimeMillis() - lastNotification < 45.minutes) {
                return false
            }
            return true
        }
    }


    private fun updateTexts(
        time: String?,
        course: String?,
        position: String?,
        teacher: String?,
        updateTime: String?
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                setTextViewTextUnlessNull(R.id.widget_time, time)
                setTextViewTextUnlessNull(R.id.widget_course, course)
                setTextViewTextUnlessNull(R.id.widget_position, position)
                setTextViewTextUnlessNull(R.id.widget_teacher, teacher)
                setTextViewTextUnlessNull(R.id.widget_update, updateTime)
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun fetchNextLessonBlocking(urlString: String): NextScheduleFetchResult {
        try {
            val request = Request.Builder()
                .url(urlString)
                .get()
                .build()
            val response = Shared.okHttpClient
                .newCall(request)
                .execute()
            val responseString = response
                .takeIf { it.isSuccessful }
                ?.body
                ?.string()
            if (responseString == null) {
                val failureMessage = "Server Returned ${response.code}"
                logException(IOException(failureMessage))
                return NextScheduleFetchResult(
                    successful = false,
                    cancelled = false,
                    failureReason = failureMessage
                )
            }
            if (Thread.interrupted()) throw InterruptedException()
            return NextScheduleFetchResult(
                successful = true,
                cancelled = false,
                result = responseString
            )
        } catch (e: IOException) {
            e.printStackTrace()
            logException(e)
            return NextScheduleFetchResult(
                successful = false,
                cancelled = false,
                failureReason = "连接错误: $e"
            )
        } catch (e: InterruptedException) {
            logException(e)
            return NextScheduleFetchResult(
                successful = false,
                cancelled = true
            )
        }
    }

    @Synchronized
    private fun logException(e: Throwable) {
        try {
            val logDir = context.getExternalFilesDir(null)
            val currentLogFile = File(logDir, "Logs/Log-${TimeUtil.dateString()}.txt")
            currentLogFile.parentFile?.mkdirs()
            FileWriter(currentLogFile, true).buffered().use { writer ->
                PrintWriter(writer).apply {
                    println(
                        "Exception at ${TimeUtil.dateTimeString()}" +
                                "========================================"
                    )
                    e.printStackTrace(this)
                    println()
                }
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }
}