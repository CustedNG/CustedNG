import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/symbols.dart';
import 'package:custed2/core/lisp_module/core_base.dart';
import 'package:custed2/core/lisp_module/core_hash.dart';
import 'package:custed2/core/lisp_module/core_http.dart';
import 'package:custed2/core/lisp_module/core_scheme.dart';

/// Makes a Lisp interpreter.
Future<LispInterp> lispMakeInterp() async {
  // Dart initializes static variables lazily.  Therefore, all keywords are
  // referred explicitly here so that they are initialized as keywords
  // before any occurrences of symbols of their names.
  [
    Symbols.cond,
    Symbols.lambda,
    Symbols.macro,
    Symbols.progn,
    Symbols.quasiquote,
    Symbols.quote,
    Symbols.setq,
    Symbols.require,
  ];

  final interp = LispInterp();
  interp.register('core/base', (interp) => LMCoreBase(interp));
  interp.register('core/scheme', (interp) => LMCoreScheme(interp));
  interp.register('core/http', (interp) => LMCoreHttp(interp));
  interp.register('core/hash', (interp) => LMCoreHash(interp));
  // await interp.evalString(_prelude, null);
  return interp;
}
