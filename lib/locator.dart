import 'package:custed2/cmds/box.dart';
import 'package:custed2/cmds/echo.dart';
import 'package:custed2/cmds/help.dart';
import 'package:custed2/cmds/snake.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/service/cookie_service.dart';
import 'package:custed2/service/user_service.dart';
import 'package:custed2/service/weather_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocatorForProviders() {
  locator.registerSingleton(DebugProvider());
  locator.registerSingleton(SnakebarProvider());
}

void setupLocator() {
  locator.registerLazySingleton(() => CookieService());
  locator.registerLazySingleton(() => WeatherService());

  locator.registerSingletonAsync((_) => UserDataService()..init());

  locator.registerLazySingleton(() {
    return TTYExecuter()
      ..register(BoxCommand())
      ..register(EchoCommand())
      ..register(HelpCommand())
      ..register(SnakeCommand());
  });
}
