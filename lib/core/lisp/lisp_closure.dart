import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_defined_func.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_lambda.dart';
import 'package:custed2/core/lisp/lisp_util.dart';

/// Compiled lambda expresssion (Closure with environment)
class LispClosure extends LispDefinedFunc {
  /// The environment of the closure
  final LispCell env;

  LispClosure(int carity, LispCell body, this.env): super(carity, body);
  LispClosure.from(LispLambda x, LispCell env): this(x.carity, x.body, env);
  @override String toString() => "#<closure:$carity:${LispUtil.str(env)}:${LispUtil.str(body)}>";

  /// Makes an environment to evaluate the body from a list of actual args.
  Future<LispCell> makeEnv(LispInterp interp, LispCell arg, LispCell interpEnv) async {
    final frame = makeFrame(arg);
    await evalFrame(frame, interp, interpEnv);
    return LispCell(frame, env);    // Prepends the frame to the closure's env.
  }

  static LispDefinedFunc make(int carity, LispCell body, LispCell env) =>
    LispClosure(carity, body, env);
}
