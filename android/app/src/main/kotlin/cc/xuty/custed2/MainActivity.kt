package cc.xuty.custed2

import android.app.Activity
import android.graphics.Color
import android.os.Build
import android.view.View
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {
    override fun onResume() {
        super.onResume()
        transparentStatusAndNavigation()
    }
}

fun Activity.transparentStatusAndNavigation(
    systemUiScrim: Int = Color.parseColor("#40000000") // 25% black
) {
    var systemUiVisibility = 0
    // Use a dark scrim by default since light status is API 23+
    var statusBarColor = systemUiScrim
    //  Use a dark scrim by default since light nav bar is API 27+
    var navigationBarColor = systemUiScrim
    val winParams = window.attributes


    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
        systemUiVisibility = systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
        statusBarColor = Color.TRANSPARENT
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        systemUiVisibility = systemUiVisibility or View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
        navigationBarColor = Color.TRANSPARENT
    }
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
        winParams.flags = winParams.flags and
                (WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS or
                        WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION).inv()
        window.statusBarColor = statusBarColor
        window.navigationBarColor = navigationBarColor
    }

    window.attributes = winParams
}
