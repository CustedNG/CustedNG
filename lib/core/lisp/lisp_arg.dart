import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';

/// Bound variable in a compiled lambda/macro expression
class LispArg {
  final int level;
  final int offset;
  final LispSym symbol;

  LispArg(this.level, this.offset, this.symbol);
  @override String toString() => "#$level:$offset:$symbol";

  /// Sets a value [x] to the location corresponding to the variable in [env].
  void setValue(x, LispCell env) {
    for (int i = 0; i < level; i++)
      env = env.cdr;
    env.car[offset] = x;
  }

  /// Gets a value from the location corresponding to the variable in [env].
  getValue(LispCell env) {
    for (int i = 0; i < level; i++)
      env = env.cdr;
    return env.car[offset];
  }
}