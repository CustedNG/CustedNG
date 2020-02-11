import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_util.dart';

abstract class LispFunc {
  /// Number of arguments, made negative if the function has &rest
  final int carity;

  int get arity => (carity < 0) ? -carity : carity;
  bool get hasRest => (carity < 0);
  int get fixedArgs => (carity < 0) ? -carity - 1 : carity; // # of fixed args.

  LispFunc(this.carity);

  /// Makes a frame for local variables from a list of actual arguments.
  List makeFrame(LispCell arg) {
    List frame = List(arity);
    int n = fixedArgs;
    int i;
    for (i = 0; i < n && arg != null; i++) {
      // Sets the list of fixed args.
      frame[i] = arg.car;
      arg = LispUtil.cdrCell(arg);
    }
    if (i != n || (arg != null && !hasRest)) {
      throw LispEvalException("arity not matched", this);
    }
    if (hasRest) frame[n] = arg;
    return frame;
  }

  /// Evaluates each expression in a frame.
  Future<void> evalFrame(List frame, LispInterp interp, LispCell env) async {
    int n = fixedArgs;
    for (int i = 0; i < n; i++) {
      frame[i] = await interp.eval(frame[i], env);
    }
    if (hasRest && frame[n] is LispCell) {
      LispCell z;
      LispCell y;
      for (LispCell j = frame[n]; j != null; j = LispUtil.cdrCell(j)) {
        var e = await interp.eval(j.car, env);
        LispCell x = LispCell(e, null);
        if (z == null) {
          z = x;
        } else {
          y.cdr = x;
        }
        y = x;
      }
      frame[n] = z;
    }
  }
}
