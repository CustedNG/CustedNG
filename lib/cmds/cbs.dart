import 'package:custed2/config/routes.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class CbsCommand extends TTYCommand {
  @override
  final name = 'cbs';

  @override
  final help = 'Custed Backup Service (beta)';

  @override
  main(TTYExecuter executer, BuildContext context,  List<String> args) {
    cbsPage.go(context);
  }
}