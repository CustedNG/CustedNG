import 'package:custed2/core/tty/executer.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void runScript(String filename, BuildContext context) async {
  final executer = locator<TTYExecuter>();
  final script = await rootBundle.loadString('assets/script/$filename');
  executer.execute(script, context, quiet: true);
}