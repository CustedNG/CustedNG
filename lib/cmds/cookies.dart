import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';

class CookiesCommand extends TTYCommand {
  @override
  final name = 'cookies';

  @override
  final help = 'cookies [clear]';

  @override
  final alias = 'ckl';

  @override
  main(TTYExecuter executer, BuildContext context,  List<String> args) {
    if (args.isNotEmpty) {
      return _runSubCommand(args);
    }
    
    final buffer = StringBuffer();
    final domains = locator<PersistCookieJar>().domains;

    buffer.writeln('COOKIES:');
    buffer.writeln('');

    for (var domain in domains) {
      for (var host in domain.keys) {
        buffer.writeln(host);
        for (var path in domain[host].keys) {
          buffer.writeln('  ' + path);
          for (var cookieName in domain[host][path].keys) {
            final cookie = domain[host][path][cookieName];
            buffer.writeln('    $cookieName: $cookie');
          }
        }
      }
    }

    locator<DebugProvider>().addMultiline(buffer.toString());
  }

  void _runSubCommand(List<String> args) {
    if (args[0] == 'clear') {
      return _runClear();
    }

    if (args[0] == 'dump') {
      return _runDump(Uri.parse(args[1]));
    }
  }

  void _runClear() {
    locator<PersistCookieJar>().deleteAll();
    print('Cookies all cleared');
  }

  void _runDump(Uri uri) {
    final cookies = locator<PersistCookieJar>().loadForRequest(uri);
    print('COOKIES FOR: $uri');
    print(cookies);
  }
}
