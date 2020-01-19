import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';


class Test2Command extends TTYCommand {
  @override
  final name = 'test2';

  @override
  final help = 'No guaranty what happens, again.';

  @override
  final alias = 'tt';

  @override
  main(TTYExecuter executer, List<String> args) async {
    print('boom');
  }
}
