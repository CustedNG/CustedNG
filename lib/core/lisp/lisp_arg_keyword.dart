import 'package:custed2/core/lisp/lisp_arg.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';

/// Bound variable in a compiled lambda/macro expression
class LispArgKeyword implements LispArg {
  final int level;
  final String key;
  final LispSym symbol;

  LispArgKeyword(this.level, this.key, this.symbol);

  @override
  String toString() => "#$level:$key:$symbol";

  /// Sets a value [x] to the location corresponding to the variable in [env].
  void setValue(x, LispCell env) {
    for (int i = 0; i < level; i++) {
      env = env.cdr;
    }
    env.car.keyword[key] = x;
  }

  /// Gets a value from the location corresponding to the variable in [env].
  getValue(LispCell env) {
    for (int i = 0; i < level; i++) {
      env = env.cdr;
    }
    return env.car.keyword[key];
  }

  LispArg copyWith({int level, key, LispSym symbol}) {
    return LispArgKeyword(
      level ?? this.level,
      key ?? this.key,
      symbol ?? this.symbol,
    );
  }
}
