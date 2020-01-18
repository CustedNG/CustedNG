import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:hive/hive.dart';

class BoxCommand extends TTYCommand {
  @override
  final name = 'box';

  @override
  final help = 'box <boxname> <key>';

  @override
  main(TTYExecuter executer, List<String> args) {
    final name = args[0];
    final key = args[1];
    print(Hive.box(name).get(key));
  }
}