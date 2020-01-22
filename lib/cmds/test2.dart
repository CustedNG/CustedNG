import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/cas_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class Test2Command extends TTYCommand {
  @override
  final name = 'test2';

  @override
  final help = 'No guaranty what happens, again.';

  @override
  final alias = 'tt';

  @override
  main(TTYExecuter executer, BuildContext context, List<String> args) async {
    // locator<SnakebarProvider>().catchAll(() {
    //   throw 'hahaha';
    // });
    Widget t = Table(
      border: TableBorder.all(color: CupertinoColors.white),
      children: [
        TableRow(children: [
          SizedBox(height: 130, child: Text('hello')),
          Text('hello'),
          Text('hello'),
        ]),
        TableRow(children: [
          Text('hello'),
          Text('hello'),
          Text('hello'),
        ]),
        TableRow(children: [
          Text('hello'),
          Text('hello'),
          Text('hello'),
        ]),
      ],
    );

    t = SizedBox(
      height: 200,
      child: t,
    );

    locator<DebugProvider>().addWidget(t);
  }
}
