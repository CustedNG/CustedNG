import 'dart:async';

import 'package:custed2/app.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/platform/os/app_doc_dir.dart';
import 'package:custed2/ui/pages/init_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

final debugProvider = DebugProvider();
final userProvider = UserProvider();

final providers = <SingleChildCloneableWidget>[
  ChangeNotifierProvider(create: (_) => debugProvider),
];

Future<void> initHive() async {
  final docDir = await getAppDocDir.invoke();
  Hive.init(docDir);
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  await Future.wait([userProvider.ensureBoxOpen()]);
}

void runAppInZone(Widget root) {
  final zoneSpec = ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      parent.print(zone, line);
      debugProvider.addText(line);
    },
  );

  final onError = (Object obj, StackTrace stack) {
    print('error: $obj');
    debugProvider.addError(obj);
  };

  runZoned(
    () => runApp(root),
    zoneSpecification: zoneSpec,
    onError: onError,
  );
}

void main() {
  runAppInZone(
    MultiProvider(
      providers: providers,
      child: FutureBuilder(
        // 初始化本地存储
        future: initApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Custed();
          }
          // 初始化完成之前无限转圈
          return InitPage();
        },
      ),
    ),
  );
}
