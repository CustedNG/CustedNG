import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';

class ClearCommand extends TTYCommand {
  @override
  final name = 'clear';

  @override
  final help = 'Clear terminal';

  @override
  final alias = 'c';

  @override
  main(TTYExecuter executer, List<String> args) {
    locator<DebugProvider>().clear();
  }
}