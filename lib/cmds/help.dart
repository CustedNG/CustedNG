import 'package:custed2/core/tty/command.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:flutter/material.dart';

class HelpCommand extends TTYCommand {
  @override
  final name = 'help';

  @override
  final help = 'Print help information';

  @override
  final alias = 'h';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) {
    final builder = StringBuffer();

    builder.writeln('');
    builder.writeln('  AVALIABLE COMMANDS:');
    builder.writeln('');

    for (var cmd in executer.commands) {
      builder.writeln('  ' +
          cmd.name.padRight(10) +
          (cmd.alias ?? '').padRight(6) +
          cmd.help);
    }

    locator<DebugProvider>().addMultiline(
      builder.toString(),
      Colors.white,
    );
  }
}
