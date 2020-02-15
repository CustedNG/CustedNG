import 'package:custed2/core/lisp/lisp_arg.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';

/// Bound variable in a compiled lambda/macro expression
class LispArgPositioned implements LispArg {
  final int level;
  final int offset;
  final LispSym symbol;

  LispArgPositioned(this.level, this.offset, this.symbol);

  @override
  String toString() => "#$level:$offset:$symbol";

  /// Sets a value [x] to the location corresponding to the variable in [env].
  void setValue(x, LispCell env) {
    for (int i = 0; i < level; i++) {
      env = env.cdr;
    }
    env.car.positioned[offset] = x;
  }

  /// Gets a value from the location corresponding to the variable in [env].
  getValue(LispCell env) {
    for (int i = 0; i < level; i++) {
      env = env.cdr;
    }
    return env.car.positioned[offset];
  }

  LispArg copyWith({int level, key, LispSym symbol}) {
    return LispArgPositioned(
      level ?? this.level,
      key ?? this.offset,
      symbol ?? this.symbol,
    );
  }
}
