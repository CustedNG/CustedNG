import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_func.dart';

/// Common base class of functions which are defined with Lisp expressions
abstract class LispDefinedFunc extends LispFunc {
  /// Lisp list as the function body
  final LispCell body;

  LispDefinedFunc(int carity, this.body): super(carity);
}