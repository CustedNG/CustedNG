import 'package:custed2/core/lisp/lisp_util.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

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
      final engine = TTYEngine(executer, context);
      await engine.init();
      final result = await engine.eval(args.join(' '));
      print('-> ${LispUtil.str(result)}');
    } catch (e) {
      print('-> $e');
    }
  }
}
