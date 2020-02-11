import 'package:custed2/core/lisp/lisp_sym.dart';

/// Expression keyword
class LispKeyword extends LispSym {
  LispKeyword.internal(String name): super.internal(name);
  factory LispKeyword(String name) => LispSym(name, true);
}