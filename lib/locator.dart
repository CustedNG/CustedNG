import 'package:alice/alice.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/api/mysso.dart';
import 'package:custed2/api/sys8.dart';
import 'package:custed2/api/webvpn.dart';
import 'package:custed2/cmds/box.dart';
import 'package:custed2/cmds/clear.dart';
import 'package:custed2/cmds/cookies.dart';
import 'package:custed2/cmds/echo.dart';
import 'package:custed2/cmds/help.dart';
import 'package:custed2/cmds/http.dart';
import 'package:custed2/cmds/ls.dart';
import 'package:custed2/cmds/snake.dart';
import 'package:custed2/cmds/test.dart';
import 'package:custed2/cmds/test2.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/sys8_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:custed2/store/cookie_store.dart';
import 'package:custed2/store/user_store.dart';
import 'package:custed2/store/weather_store.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';

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
      ..register(Test2Command())
      ..register(ClearCommand())
      ..register(CookiesCommand())
      ..register(LsCommand())
      ..register(HttpCommand());
  });

  locator.registerLazySingleton(
    () => PersistCookieJar(dir: path.join(docDir, ".cookies/")),
  );

  locator.registerLazySingleton(
      () => Alice(darkTheme: true, showNotification: false));

  locator.registerFactory(() {
    final cookieJar = locator<PersistCookieJar>();
    final alice = locator<Alice>();
    return Dio()
      ..options.headers['user-agent'] =
          'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36'
      ..transformer = FlutterTransformer()
      ..interceptors.add(CookieManager(cookieJar))
      ..interceptors.add(alice.getDioInterceptor());
  });

  locator.registerLazySingleton(() => MyssoApi());
  locator.registerLazySingleton(() => MyssoService());
  locator.registerLazySingleton(() => Sys8Api());
  locator.registerLazySingleton(() => Sys8Service());
  locator.registerLazySingleton(() => WebvpnApi());
  locator.registerLazySingleton(() => WebvpnService());
}
