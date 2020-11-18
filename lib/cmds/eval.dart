import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/engine.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:flutter/material.dart';

class EvalCommand extends TTYCommand {
  @override
  final name = 'eval';

  @override
  final help = 'evaluate lisp expression';

  @override
  final alias = '.';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) async {
    try {
      final engine = TTYEngine();
      await engine.init();
      final result = await engine.eval(args.join(' '));
      print('-> ${result}');
    } catch (e) {
      print('-> $e');
    }
  }
}
