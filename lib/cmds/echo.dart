import 'package:custed2/core/tty/command.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class EchoCommand extends TTYCommand {
  @override
  final name = 'echo';

  @override
  final help = 'echo <string>';

  @override
  main(TTYExecuter executer, BuildContext context,  List<String> args) {
    print(args.join(' '));
  }
}