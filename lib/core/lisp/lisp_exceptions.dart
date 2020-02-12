import 'package:custed2/core/lisp/lisp_util.dart';

/// Exception in evaluation
class LispEvalException implements Exception {
  final String message;
  final List<String> trace = [];

  LispEvalException(String msg, Object x, [bool quoteString = true])
      : message = msg + ": " + LispUtil.str(x, quoteString);

  static void ensure(bool cond, String msg, Object x, [bool quoteString = true]) {
    if (cond == false) {
      throw LispEvalException(msg, x, quoteString);
    }
  }

  @override
  String toString() {
    var s = "EvalException: $message";
    for (String line in trace) {
      s += "\n\t$line";
    }
    return s;
  }
}

/// Exception which indicates an absence of a variable
class LispNotVariableException extends LispEvalException {
  LispNotVariableException(x) : super("variable expected", x);
}
