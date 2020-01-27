import 'package:alice/alice.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/config/commands.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/app_provider.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/data/store/schedule_store.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;

GetIt locator = GetIt.instance;

void setupLocatorForServices() {
  locator.registerLazySingleton(() => MyssoService());
  locator.registerLazySingleton(() => JwService());
  locator.registerLazySingleton(() => CustedService());
}

void setupLocatorForProviders() {
  locator.registerSingleton(DebugProvider());
  locator.registerSingleton(SnakebarProvider());
  locator.registerSingleton(ScheduleProvider());
  locator.registerSingleton(UserProvider());
  locator.registerSingleton(AppProvider());
  locator.registerSingleton(WeatherProvider());
}

Future<void> setupLocatorForStores() async {
  final setting = SettingStore();
  await setting.init();
  locator.registerSingleton(setting);

  locator.registerSingletonAsync<UserDataStore>((_) async {
    final store = UserDataStore();
    await store.init();
    return store;
  });

  locator.registerSingletonAsync<ScheduleStore>((_) async {
    final store = ScheduleStore();
    await store.init();
    return store;
  });
}

Future<void> setupLocator(String docDir) async {
  await setupLocatorForStores();

  setupLocatorForProviders();

  locator.registerLazySingleton(() {
    final instance = TTYExecuter();
    instance.cd(docDir);
    commands.forEach((c) => instance.register(c));
    return instance;
  });

  locator.registerLazySingleton(
    () => PersistCookieJar(dir: path.join(docDir, ".cookies/")),
  );

  locator.registerSingleton(GlobalKey<NavigatorState>());

  locator.registerLazySingleton(
    () => Alice(
      // I will fix darkTheme someday...
      darkTheme: false,
      showNotification: false,
      navigatorKey: locator<GlobalKey<NavigatorState>>(),
    ),
  );

  setupLocatorForServices();
}
