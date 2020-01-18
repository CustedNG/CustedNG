import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/cmds/box.dart';
import 'package:custed2/cmds/clear.dart';
import 'package:custed2/cmds/echo.dart';
import 'package:custed2/cmds/help.dart';
import 'package:custed2/cmds/snake.dart';
import 'package:custed2/cmds/test.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/service/cookie_service.dart';
import 'package:custed2/service/user_service.dart';
import 'package:custed2/service/weather_service.dart';
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
  locator.registerLazySingleton(() => CookieService());
  locator.registerLazySingleton(() => WeatherService());

  locator.registerSingletonAsync((_) => UserDataService()..init());

  locator.registerLazySingleton(() {
    return TTYExecuter()
      ..register(BoxCommand())
      ..register(EchoCommand())
      ..register(HelpCommand())
      ..register(SnakeCommand())
      ..register(TestCommand())
      ..register(ClearCommand());
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
}
