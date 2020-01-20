import 'dart:io';

import 'package:custed2/core/tty/command.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';
import 'package:path/path.dart' as path;

class LsCommand extends TTYCommand {
  @override
  final name = 'ls';

  @override
  final help = 'ls [dir]';

  @override
  main(TTYExecuter executer, BuildContext context,  List<String> args) async {
    final buffer = StringBuffer();

    final target =
        args.isEmpty ? executer.cwd : path.join(executer.cwd, args[0]);

    await for (var entity in Directory(target).list()) {
      buffer.writeln(entity.path);
    }

    locator<DebugProvider>().addMultiline(buffer.toString());
  }
}
