import 'package:after_layout/after_layout.dart';
import 'package:custed2/app_frame.dart';
import 'package:custed2/core/analytics.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/setting_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool _shouldEnableDarkMode(BuildContext context, int mode) {
  // print('ddf: ${MediaQuery.platformBrightnessOf(context)}');
  if (mode == DarkMode.on) return true;
  if (mode == DarkMode.off) return false;
  return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
}

class Custed extends StatefulWidget {
  @override
  _CustedState createState() => _CustedState();
}

class _CustedState extends State<Custed> with AfterLayoutMixin<Custed> {
  @override
  Widget build(BuildContext context) {
    final setting = locator<SettingStore>();

    return SettingBuilder(
      setting: setting.darkMode,
      builder: (context, mode) {
        return CupertinoApp(
          navigatorKey: locator<GlobalKey<NavigatorState>>(),
          title: 'Custed',
          home: AppFrame(),
          builder: (context, child) {
            bool isDarkMode = _shouldEnableDarkMode(context, mode);
            return CupertinoTheme(
              data: CupertinoThemeData(
                brightness: isDarkMode ? Brightness.dark : Brightness.light,
              ),
              child: Builder(
                builder: (context) => DefaultTextStyle(
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                  child: child,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 在这里进行初始化，避免启动掉帧
  @override
  void afterFirstLayout(BuildContext context) async {
    final path = await getAppDocDir.invoke();
    print('AppDocDir: $path');

    final debug = locator<DebugProvider>();
    debug.addMultiline(r'''
  
      _____         __         __   
     / ___/_ _____ / /____ ___/ /   
    / /__/ // (_-</ __/ -_) _  /    
    \___/\_,_/___/\__/\__/\_,_/     

      App First Layout Done. 
  
    ''');

    // 启动外围服务
    if (BuildMode.isRelease) {
      Analytics.init();
      Analytics.isDebug = BuildMode.isDebug;
      locator<WeatherProvider>().startAutoUpdate();
    }

    // 加载核心数据
    await Future.wait([
      locator<ScheduleProvider>().loadLocalData(),
      locator<GradeProvider>().loadLocalData(),
      locator<UserProvider>().loadLocalData(),
    ]);

    // 预热 IecardService
    // final user = locator<UserProvider>();
    // await user.initialized;
    // if (user.loggedIn) {
    //   IecardService().login();
    // }
  }
}
