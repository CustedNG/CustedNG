import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_func.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';

/// Function type which represents any built-in function body
typedef LispBuiltInFuncBody(List frame);

/// Built-in function
class LispBuiltInFunc extends LispFunc {
  final String name;
  final LispBuiltInFuncBody body;

  LispBuiltInFunc(this.name, int carity, this.body) : super(carity);

  @override
  String toString() => "#<$name:$carity>";

  /// Invokes the built-in function with a list of actual arguments.
  Future evalWith(LispInterp interp, LispCell arg, LispCell interpEnv) async {
    List frame = makeFrame(arg);
    await evalFrame(frame, interp, interpEnv);
    try {
      return Future.sync(() => body(frame));
    } on LispEvalException catch (_) {
      rethrow;
    } catch (ex) {
      throw LispEvalException("$ex -- $name", frame);
    }
  }
}
