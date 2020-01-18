import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';

class TestCommand extends TTYCommand {
  @override
  final name = 'test';

  @override
  final help = 'No guaranty what happens.';

  @override
  final alias = 't';

  @override
  main(TTYExecuter executer, List<String> args) async {
    locator<MyssoService>().login();
  }
}