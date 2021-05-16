package cc.xuty.custed2

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import cc.xuty.custed2.R
import org.json.JSONObject
import java.net.URL
import java.net.HttpURLConnection
import kotlinx.coroutines.*

class HomeWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {

        var data: JSONObject? = null
        GlobalScope.launch {
            var urlString = "https://push.lolli.tech/schedule/next/" + widgetData.getString("ecardId", "")
            var url = URL(urlString)
            var connection = url.openConnection() as HttpURLConnection
            connection.connectTimeout = 5 * 1000  // 设置连接超时时间
            connection.readTimeout = 5 * 1000  //设置从主机读取数据超时
            connection.doOutput = true
            connection.doInput = true
            connection.useCaches = false
            connection.requestMethod = "GET"
            try {
                connection.connect()
                var text = connection.inputStream.use { it.reader().use { reader -> reader.readText() } }
                data = JSONObject(text)
            } finally {
                connection.disconnect()
            }
        }
        

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                setTextViewText(R.id.widget_course, data?.getString("Course").toString())
                setTextViewText(R.id.widget_position, "12")
            }

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}