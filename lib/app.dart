import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:alice/alice.dart';
import 'package:custed2/app_frame.dart';
import 'package:custed2/core/analytics.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/setting_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_widget/home_widget.dart';
import 'package:plain_notification_token/plain_notification_token.dart';
import 'package:xiao_mi_push_plugin/xiao_mi_push_plugin.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';

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
  void initState() {
    super.initState();
    setSystemBottomNavigationBarColor(context);
  }

  @override
  Widget build(BuildContext context) {
    final setting = locator<SettingStore>();

    return SettingBuilder(
      setting: setting.darkMode,
      builder: (context, mode) {
        return MaterialApp(
          title: 'Custed',
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('zh')],
          navigatorKey: locator<Alice>().getNavigatorKey(),
          debugShowCheckedModeBanner: false,
          home: AppFrame(),
          builder: (context, child) {
            bool isDarkMode = _shouldEnableDarkMode(context, mode);
            Color primary = Color(setting.appPrimaryColor.fetch());
            return Theme(
                data: ThemeData(
                  primaryColor: isDarkMode ? null : primary,
                  brightness: isDarkMode ? Brightness.dark : Brightness.light,
                ),
                child: child);
          },
        );
      },
    );
  }

  // 在这里进行初始化，避免启动掉帧
  @override
  void afterFirstLayout(BuildContext context) async {
    final setting = locator<SettingStore>();
    final weatherProvider = locator<WeatherProvider>();

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
      Analytics.isDebug = false;
    }
    if (setting.autoUpdateWeather.fetch()) weatherProvider.startAutoUpdate();
    weatherProvider.update();

    final user = locator<UserProvider>();
    // 加载核心数据
    await Future.wait([
      locator<ScheduleProvider>().loadLocalData(resetWeek: true),
      locator<GradeProvider>().loadLocalData(),
      user.loadLocalData(),
    ]);

    await user.initialized;
    if (user.loggedIn) {
      await locator<ExamProvider>().init();
      // 预热 IecardService
      // IecardService().login();

      final userData = locator<UserDataStore>();
      final userName = userData.username.fetch();
      print('User name is $userName');
      if (userName == null) {
        return;
      }

      await initPushService(userName);
      await requestUpdateHomeWidget(userName, setting.pushNotification.fetch());
    }
  }
}

Future<void> initPushService(String userName) async {
  String token = await getToken();
  if (token == null) {
    print('get token failed');
    return;
  }
  await CustedService().sendToken(token, Platform.isIOS);
}

Future<String> getToken() async {
  if (Platform.isIOS) {
    final plainNotificationToken = PlainNotificationToken();
    plainNotificationToken.requestPermission();
    await plainNotificationToken.onIosSettingsRegistered.first;
    // wait for user to give notification permission
    await Future.delayed(Duration(seconds: 3));
    return await plainNotificationToken.getToken();
  } else {
    await XiaoMiPushPlugin.init(
        appId: "2882303761518813144", appKey: "5601881368144");
    return await XiaoMiPushPlugin.getRegId();
  }
}

Future<void> requestUpdateHomeWidget(String userName, bool enablePush) async {
  if (Platform.isIOS) await HomeWidget.setAppGroupId('group.com.tusi.app');
  final setIdResult =
      await HomeWidget.saveWidgetData('ecardId', userName ?? '');
  print('set ecardId for home widget: ${setIdResult ? "success" : "failed"}');

  if (Platform.isAndroid) {
    final setPushResult =
        await HomeWidget.saveWidgetData('enableLessonPush', enablePush);
    print('set lessonPush for home widget successfully? $setPushResult');
    HomeWidget.updateWidget(
        name: 'HomeWidgetProvider', androidName: 'HomeWidgetProvider');
  }
}
