import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_defined_func.dart';
import 'package:custed2/core/lisp/lisp_util.dart';

/// Compiled lambda expression (Within another function)
class LispLambda extends LispDefinedFunc {
  LispLambda(int carity, LispCell body): super(carity, body);
  @override String toString() => "#<lambda:$carity:${LispUtil.str(body)}>";

  static LispDefinedFunc make(int carity, LispCell body, LispCell env) {
    assert(env == null);
    return LispLambda(carity, body);
  }
}