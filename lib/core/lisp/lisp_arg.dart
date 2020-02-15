import 'package:custed2/core/lisp/lisp_arg_keyword.dart';
import 'package:custed2/core/lisp/lisp_arg_positioned.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';

/// Bound variable in a compiled lambda/macro expression
abstract class LispArg {
  final int level;
  final LispSym symbol;

  factory LispArg(int level, key, LispSym symbol) {
    if (key is int) return LispArgPositioned(level, key, symbol);
    if (key is String) return LispArgKeyword(level, key, symbol);
    throw LispEvalException('LispArg key must be either int or String', key);
  }

  /// Sets a value [x] to the location corresponding to the variable in [env].
  void setValue(x, LispCell env);

  /// Gets a value from the location corresponding to the variable in [env].
  getValue(LispCell env);

  LispArg copyWith({int level, key, LispSym symbol});
}