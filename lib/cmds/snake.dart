import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/locator.dart';

typedef SnakeSubCommandHandler = void Function(List<String> args);

class SnakeCommand extends TTYCommand {
  @override
  final name = 'snake';

  @override
  final help = 'snake <info|clear> [message]';

  @override
  main(TTYExecuter executer, List<String> args) {
    final handlers = <String, SnakeSubCommandHandler>{
      'info': _infoHandler,
      'clear': _clearHandler,
    };

    final subcmd = args[0];
    final handler = handlers[subcmd];

    if (handler == null) {
      print('no such subcommand: $subcmd');
      return;
    }

    handler(args.sublist(1));
  }

  _infoHandler(List<String> args) {
    final message = args.join(' ');
    final snakebar = locator<SnakebarProvider>();
    snakebar.info(message);
  }

  _clearHandler(List<String> args) {
    final snakebar = locator<SnakebarProvider>();
    snakebar.clear();
  }


}