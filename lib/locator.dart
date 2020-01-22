import 'package:alice/alice.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/cmds/box.dart';
import 'package:custed2/cmds/clear.dart';
import 'package:custed2/cmds/cookies.dart';
import 'package:custed2/cmds/echo.dart';
import 'package:custed2/cmds/help.dart';
import 'package:custed2/cmds/http.dart';
import 'package:custed2/cmds/ls.dart';
import 'package:custed2/cmds/new_year.dart';
import 'package:custed2/cmds/snake.dart';
import 'package:custed2/cmds/test.dart';
import 'package:custed2/cmds/test2.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/schedule_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/store/schedule_store.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/data/store/cookie_store.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/data/store/weather_store.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;

GetIt locator = GetIt.instance;

void setupLocatorForProviders() {
  locator.registerSingleton(DebugProvider());
  locator.registerSingleton(SnakebarProvider());
  locator.registerSingleton(ScheduleProvider());
}

void setupLocator(String docDir) {
  locator.registerLazySingleton(() => CookieStore());
  locator.registerLazySingleton(() => WeatherStore());

  locator.registerSingletonAsync<UserDataStore>( (_) async { 
    final store = UserDataStore();
    await store.init();
    return store;
  });
  
  locator.registerSingletonAsync<ScheduleStore>( (_) async { 
    final store = ScheduleStore();
    await store.init();
    return store;
  });

  locator.registerLazySingleton(() {
    return TTYExecuter()
      ..cd(docDir)
      ..register(BoxCommand())
      ..register(EchoCommand())
      ..register(HelpCommand())
      ..register(SnakeCommand())
      ..register(TestCommand())
      ..register(Test2Command())
      ..register(ClearCommand())
      ..register(CookiesCommand())
      ..register(LsCommand())
      ..register(HttpCommand())
      ..register(NewYearCommand());
  });

  locator.registerLazySingleton(
    () => PersistCookieJar(dir: path.join(docDir, ".cookies/")),
  );

  locator.registerLazySingleton(
      () => Alice(darkTheme: true, showNotification: false));

  locator.registerLazySingleton(() => MyssoService());
  locator.registerLazySingleton(() => JwService());
}
