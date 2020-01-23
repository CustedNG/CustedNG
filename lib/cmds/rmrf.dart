import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:hive/hive.dart';

class RmrfCommand extends TTYCommand {
  @override
  final name = 'rmrf';

  @override
  final help = 'Alias for infamous "sudo rm -rf"';

  @override
  main(TTYExecuter executer, BuildContext context,  List<String> args) {
    print('sudo rm -rf');
    locator<PersistCookieJar>().deleteAll();
    Hive.deleteFromDisk();
    print('done');
    print('All local data has been wiped out, please restart.');
  }
}