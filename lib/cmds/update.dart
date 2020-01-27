import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/update.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class UpdateCommand extends TTYCommand {
  @override
  final name = 'update';

  @override
  final help = 'Force update';

  @override
  main(TTYExecuter executer, BuildContext context,  List<String> args) {
    updateCheck(context, force: true);
  }
}