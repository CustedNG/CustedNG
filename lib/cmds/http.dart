import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HttpCommand extends TTYCommand {
  @override
  final name = 'http';

  @override
  final help = 'Show http inspector';

  @override
  final alias = 'i';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) {
    //final alice = locator<Alice>();
    // final key = GlobalKey<NavigatorState>();
    // final app = MaterialApp(
    //   navigatorKey: key,
    //   home: ,
    // );
    // MaterialApp
    //Navigator.of(context).push(CupertinoPageRoute(builder: (_) => alice.buildInspector()));
    // alice.showInspector();
    //   navigatorKey: locator<Alice>().getNavigatorKey(),
    // locator<Alice>().showInspector();
  }
}
