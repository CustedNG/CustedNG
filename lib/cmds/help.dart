import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';

class HelpCommand extends TTYCommand {
  @override
  final name = 'help';

  @override
  final help = 'Print help information';

  @override
  main(TTYExecuter executer, List<String> args) {
    final builder = StringBuffer();
    builder.writeln('AVALIABLE COMMANDS:');
    builder.writeln('');
    for (var cmd in executer.commands) {
      builder.writeln(cmd.name.padRight(10) + cmd.help);
    }
    print(builder.toString());
  }
}