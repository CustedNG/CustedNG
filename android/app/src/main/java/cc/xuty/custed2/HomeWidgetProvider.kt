package cc.xuty.custed2

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.widget.Toast
import com.fasterxml.jackson.annotation.JsonProperty
import es.antonborri.home_widget.HomeWidgetProvider
import okhttp3.Request
import java.io.IOException
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
)

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
        val urlString = "https://push.lolli.tech/schedule/next/$eCardId"
        previousTask =
            Shared.executor.submit { updateNextLesson(urlString, context, appWidgetManager, appWidgetIds, widgetData) }
    }

    private fun String?.parseNextScheduleJson(): NextSchedule {
        return if (this == null) NextSchedule(
            "-",
            "获取失败",
            "",
            "",
            IntArray(0)
        ) else Shared.objectMapper.readValue(this, NextSchedule::class.java)
    }

    private fun updateNextLesson(
        urlString: String,
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        try {
            val result = fetchNextLessonBlocking(urlString)
            val currentTime = SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date())
            if (!result.successful) {
                appWidgetIds.forEach { widgetId ->
                    val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                        setTextViewText(R.id.widget_time, "更新失败")
                        setTextViewText(R.id.widget_course, "尝试Custed内")
                        setTextViewText(R.id.widget_position, "刷新课表后")
                        setTextViewText(R.id.widget_teacher, "重新添加该小部件")
                        setTextViewText(R.id.widget_update, "更新于 $currentTime")
                    }

                    appWidgetManager.updateAppWidget(widgetId, views)
                    return
                }
            }

            if (result.result!! == "today have no more lesson") {
                appWidgetIds.forEach { widgetId ->
                    val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                        setTextViewText(R.id.widget_time, "今天")
                        setTextViewText(R.id.widget_course, "没有课了")
                        setTextViewText(R.id.widget_position, "放松一下吧")
                        setTextViewText(R.id.widget_teacher, "(｡ì _ í｡)")
                        setTextViewText(R.id.widget_update, "更新于 $currentTime")
                    }

                    appWidgetManager.updateAppWidget(widgetId, views)
                }
                return
            }

            val jsonObj = result.result.parseNextScheduleJson()

            appWidgetIds.forEach { widgetId ->
                val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                    setTextViewText(R.id.widget_time, jsonObj.startTime)
                    setTextViewText(R.id.widget_course, jsonObj.courseName)
                    setTextViewText(R.id.widget_position, jsonObj.position)
                    setTextViewText(R.id.widget_teacher, jsonObj.teacherName)
                    setTextViewText(R.id.widget_update, "更新于 $currentTime")
                }

                appWidgetManager.updateAppWidget(widgetId, views)
            }
        } catch (e: Throwable) {
            e.printStackTrace()
            throw e
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
                ?: return NextScheduleFetchResult(
                    successful = false,
                    cancelled = false,
                    failureReason = "Server Returned ${response.code}"
                )
            if (Thread.interrupted()) throw InterruptedException()
            return NextScheduleFetchResult(
                successful = true,
                cancelled = false,
                result = responseString
            )
        } catch (e: IOException) {
            e.printStackTrace()
            return NextScheduleFetchResult(
                successful = false,
                cancelled = false,
                failureReason = "连接错误: $e"
            )
        } catch (e: InterruptedException) {
            return NextScheduleFetchResult(
                successful = false,
                cancelled = true
            )
        }
    }
}