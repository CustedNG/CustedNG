import 'package:custed2/core/lisp/lisp_interp.dart';

abstract class LModule {
  LModule(this.interp);

  LispInterp interp;

  Future<void> load();
}
