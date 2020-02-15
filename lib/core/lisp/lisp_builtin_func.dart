import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_frame.dart';
import 'package:custed2/core/lisp/lisp_func.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';

/// Function type which represents any built-in function body
typedef LispBuiltInFuncBody(LispFrame frame);

/// Built-in function
class LispBuiltInFunc extends LispFunc {
  final String name;
  final LispBuiltInFuncBody body;
  final bool preserveArgs;

  LispBuiltInFunc(this.name, int carity, this.body, [this.preserveArgs = false])
      : super(carity);

  @override
  String toString() => "#<$name:$carity>";

  /// Invokes the built-in function with a list of actual arguments.
  Future evalWith(LispInterp interp, LispCell arg, LispCell interpEnv) async {
    final frame = makeFrame(arg);
    if (!preserveArgs) {
      await evalFrame(frame, interp, interpEnv);
    }
    return Future.sync(() => body(frame));
  }
}
