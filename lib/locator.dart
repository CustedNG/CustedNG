import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/api/mysso.dart';
import 'package:custed2/cmds/box.dart';
import 'package:custed2/cmds/clear.dart';
import 'package:custed2/cmds/cookies.dart';
import 'package:custed2/cmds/echo.dart';
import 'package:custed2/cmds/help.dart';
import 'package:custed2/cmds/ls.dart';
import 'package:custed2/cmds/snake.dart';
import 'package:custed2/cmds/test.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/store/cookie_store.dart';
import 'package:custed2/store/user_store.dart';
import 'package:custed2/store/weather_store.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;

GetIt locator = GetIt.instance;

void setupLocatorForProviders() {
  locator.registerSingleton(DebugProvider());
  locator.registerSingleton(SnakebarProvider());
}

void setupLocator(String docDir) {
  locator.registerLazySingleton(() => CookieStore());
  locator.registerLazySingleton(() => WeatherStore());

  locator.registerSingletonAsync((_) => UserDataStore()..init());

  locator.registerLazySingleton(() {
    return TTYExecuter()
      ..cd(docDir)
      ..register(BoxCommand())
      ..register(EchoCommand())
      ..register(HelpCommand())
      ..register(SnakeCommand())
      ..register(TestCommand())
      ..register(ClearCommand())
      ..register(CookiesCommand())
      ..register(LsCommand());
  });

  locator.registerLazySingleton(
    () => PersistCookieJar(dir: path.join(docDir, ".cookies/")),
  );

  locator.registerFactory(() {
    final cookieJar = locator<PersistCookieJar>();
    return Dio()
      ..transformer = FlutterTransformer()
      ..interceptors.add(CookieManager(cookieJar));
  });

  locator.registerLazySingleton(() => MyssoApi());
  locator.registerLazySingleton(() => MyssoService());
}
