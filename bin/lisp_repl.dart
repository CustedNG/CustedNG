import 'dart:async';
import 'dart:io';

import 'package:custed2/core/lisp/lisp.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';

LispInterp interp;

void main(List<String> args) async {
  interp = await lispMakeInterp();

  if (args.isEmpty) {
    repl();
  } else {
    loadFile(args.first);
  }
}

void loadFile(String path) {
  final source = File(path).readAsStringSync();
  eval(source);
}

void repl() async {
  for (;;) {
    stdout.write('> ');
    final line = stdin.readLineSync();
    await processLine(line);
  }
}

Future<void> processLine(String line) async {
  print(line);
  try {
    await eval(line);
  } catch (e) {
    print(e);
  }
}

Future<void> eval(String source) async {
  await interp.evalString(source, null);
}
