import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_frame.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_sym_keyword.dart';
import 'package:custed2/core/lisp/lisp_util.dart';

abstract class LispFunc {
  /// Number of arguments, made negative if the function has &rest
  final int carity;

  int get arity => (carity < 0) ? -carity : carity;
  bool get hasRest => (carity < 0);
  int get fixedArgs => (carity < 0) ? -carity - 1 : carity; // # of fixed args.

  LispFunc(this.carity);

  /// Makes a frame for local variables from a list of actual arguments.
  /// (1 . (2 . ((+ 1 2) . nil))) -> [1 2 (+ 1 2)]
  LispFrame makeFrame(LispCell arg) {
    final keyword = <String, dynamic>{};
    final positioned = List(arity);

    int collected = 0;
    while (arg != null) {
      while (arg.car is LispSymKeyword) {
        if (arg.cdr == null) {
          throw LispEvalException("value required", arg.car);
        }
        keyword[arg.car.name] = arg.cdr.car;
        arg = LispUtil.cdrCell(arg.cdr);
        if (arg == null) break;
      }

      // Sets the list of fixed args.
      if (collected >= fixedArgs) break;
      positioned[collected] = arg.car;
      arg = LispUtil.cdrCell(arg);
      collected++;
    }

    if (collected != fixedArgs || (arg != null && !hasRest)) {
      throw LispEvalException("arity not matched", this);
    }

    if (hasRest) {
      positioned[fixedArgs] = arg;
    }

    return LispFrame(positioned: positioned, keyword: keyword);
  }

  /// Evaluates each expression in a frame.
  /// [1 (+ 1 2) ...] -> [1 3 ...]
  Future<void> evalFrame(
    LispFrame frame,
    LispInterp interp,
    LispCell env,
  ) async {
    for (var key in frame.keyword.keys) {
      frame.keyword[key] = await interp.eval(frame.keyword[key], env);
    }
    int n = fixedArgs;
    for (var i = 0; i < n; i++) {
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
