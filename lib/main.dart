import 'dart:async';

import 'package:custed2/app.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/core/platform/os/app_doc_dir.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/pages/init_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  setupLocator();
}

Future<void> initHive() async {
  final docDir = await getAppDocDir.invoke();
  Hive.init(docDir);
}

void runInZone(Function body) {
  final zoneSpec = ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      final debugProvider = locator<DebugProvider>();
      parent.print(zone, line);
      debugProvider.addText(line);
    },
  );

  final onError = (Object obj, StackTrace stack) {
    final debugProvider = locator<DebugProvider>();
    print('error: $obj');
    debugProvider.addError(obj);
  };

  runZoned(
    body,
    zoneSpecification: zoneSpec,
    onError: onError,
  );
}

void main() async {
  setupLocatorForProviders();

  runInZone(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => locator<DebugProvider>()),
        ],
        child: FutureBuilder(
          future: initApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Custed();
            }
            return InitPage();
          },
        ),
      ),
    );
  });
}
