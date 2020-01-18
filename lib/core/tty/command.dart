import 'package:custed2/core/tty/executer.dart';

class TTYCommand {
  final name = 'hello';

  final help = 'hello world example';

  final String alias = null;
  
  main(TTYExecuter executer, List<String> args) {
    print('hello world!');
  }
}