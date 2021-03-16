import 'package:custed2/core/tty/command.dart';
import 'package:custed2/core/tty/engine.dart';
import 'package:custed2/core/tty/exception.dart';
import 'package:custed2/data/providers/debug_provider.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class TTYExecuter {
  final Map<String, TTYCommand> _commandMap = <String, TTYCommand>{};
  final Map<String, TTYCommand> _commandAliasMap = <String, TTYCommand>{};
  String _cwd = '/';

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

  Future<void> execute(String cmd, BuildContext context, {bool quiet = false}) async {
    try {
      final engine = locator<TTYEngine>();
      await engine.init();
      await engine.setContext(context);
      if (!quiet) print(cmd);
    } on TTYInterrupt catch (i) {
      print('-> $i');
    } catch (e, stacktrace) {
      final debugProvider = locator<DebugProvider>();
      debugProvider.addError('-> $e');
      debugProvider.addError('-> $stacktrace');
    }
  }

  void executeLegacy(String cmd, BuildContext context) {
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

    command.main(this, context, tokens.sublist(1));
  }

  void cd(String path) {
    _cwd = path;
  }

  String get cwd => _cwd;
}
