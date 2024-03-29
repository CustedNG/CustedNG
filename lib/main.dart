import 'dart:async';

import 'package:custed2/app.dart';
import 'package:custed2/core/analytics.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/models/grade_detail.dart';
import 'package:custed2/data/models/grade_term.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/cet_avatar_provider.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/data/providers/exam_provider.dart';
import 'package:custed2/data/providers/grade_provider.dart';
import 'package:custed2/data/providers/netdisk_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  final docDir = await getAppDocDir.invoke();

  Hive.init(docDir);
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(ScheduleLessonAdapter());
  Hive.registerAdapter(ScheduleLessonTypeAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(GradeAdapter());
  Hive.registerAdapter(GradeDetailAdapter());
  Hive.registerAdapter(GradeTermAdapter());

  await setupLocator(docDir);
  locator<AppProvider>().loadLocalData();
}

void runInZone(Function body) {
  final debugProvider = locator<DebugProvider>();
  final zoneSpec = ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      parent.print(zone, line);
      // This is a hack to avoid
      // `setState() or markNeedsBuild() called during build`
      // error.
      Future.delayed(Duration(milliseconds: 1), () {
        debugProvider.addText(line);
      });
    },
  );

  final onError = (Object obj, StackTrace stack) {
    print('error: $obj');
    Analytics.recordException(obj);
    debugProvider.addError(obj);
    debugProvider.addError(stack);
  };

  runZonedGuarded(
    body,
    onError,
    zoneSpecification: zoneSpec,
  );
}

void main() async {
  // debugPaintSizeEnabled = true;

  locator.registerSingleton(DebugProvider());

  runInZone(() async {
    await initApp();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<DebugProvider>()),
          ChangeNotifierProvider(create: (_) => locator<ScheduleProvider>()),
          ChangeNotifierProvider(create: (_) => locator<UserProvider>()),
          ChangeNotifierProvider(create: (_) => locator<AppProvider>()),
          ChangeNotifierProvider(create: (_) => locator<WeatherProvider>()),
          ChangeNotifierProvider(create: (_) => locator<CetAvatarProvider>()),
          ChangeNotifierProvider(create: (_) => locator<GradeProvider>()),
          ChangeNotifierProvider(create: (_) => locator<NetdiskProvider>()),
          ChangeNotifierProvider(create: (_) => locator<ExamProvider>()),
        ],
        child: Custed(),
      ),
    );
  });
}
