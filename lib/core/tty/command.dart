import 'package:custed2/core/tty/executer.dart';
import 'package:flutter/widgets.dart';

class TTYCommand {
  final name = 'hello';

  final help = 'hello world example';

  final String alias = null;
  
  main(TTYExecuter executer, BuildContext context,  List<String> args) {
    print('hello world!');
  }
}