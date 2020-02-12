import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LispModule {
  LispModule(this.interp, this.moduleLoader,);

  final LModule Function(LispInterp) moduleLoader;
  final LispInterp interp;

  bool _loaded = false;

  /// load the module into interp.
  /// return true if loaded
  /// if already loaded, return false.
  Future load() async {
    if (_loaded) return null;
    await moduleLoader(interp).load();
    _loaded = true;
    return true;
  }
}