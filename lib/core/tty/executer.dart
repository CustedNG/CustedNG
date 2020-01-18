import 'package:custed2/core/tty/command.dart';

class TTYExecuter {
  final Map<String, TTYCommand> _commandMap = <String, TTYCommand>{};
  final Map<String, TTYCommand> _commandAliasMap = <String, TTYCommand>{};

  Iterable<TTYCommand> get commands => _commandMap.values;

  void register(TTYCommand command) {
    _commandMap[command.name] = command;
    if (command.alias != null) {
      _commandAliasMap[command.alias] = command;
    }
  }

  void remove(TTYCommand command) {
    _commandMap.remove(command.name);
    if (command.alias != null) {
      _commandAliasMap.remove(command.alias);
    }
  }

  void execute(String cmd) {
    final tokens = cmd.split(RegExp(r'\s+'));

    if (tokens.isEmpty) {
      print('Empty command');
      return;
    }

    final name = tokens[0];
    final command = _commandMap[name] ?? _commandAliasMap[name];

    if (command == null) {
      print('no such command: $name');
      return;
    }

    command.main(this, tokens.sublist(1));
  }
}
