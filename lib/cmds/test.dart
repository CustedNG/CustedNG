import 'package:custed2/api/mysso.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';

class TestCommand extends TTYCommand {
  @override
  final name = 'test';

  @override
  final help = 'No guaranty what happens.';

  @override
  final alias = 't';

  @override
  main(TTYExecuter executer, List<String> args) async {
    final resp = await MyssoApi().getLoginPage();
    print(resp);
  }
}