import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/locator.dart';

class CookiesCommand extends TTYCommand {
  @override
  final name = 'cookies';

  @override
  final help = 'Dump cookies in cookieJar';

  @override
  main(TTYExecuter executer, List<String> args) {
    print(locator<PersistCookieJar>().domains);
  }
}