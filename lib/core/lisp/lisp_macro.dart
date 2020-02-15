import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_defined_func.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_util.dart';

class LispMacro extends LispDefinedFunc {
  LispMacro(int carity, LispCell body) : super(carity, body);

  @override
  String toString() => "#<macro:$carity:${LispUtil.str(body)}>";

  /// Expands the macro with a list of actual arguments.
  Future expandWith(LispInterp interp, LispCell arg) async {
    final frame = makeFrame(arg);
    final env = LispCell(frame, null);
    var x;
    for (LispCell j = body; j != null; j = LispUtil.cdrCell(j)) {
      x = await interp.eval(j.car, env);
    }
    return x;
  }

  static LispDefinedFunc make(int carity, LispCell body, LispCell env) {
    assert(env == null);
    return LispMacro(carity, body);
  }
}
