import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LMCoreDirectory extends LModule {
  LMCoreDirectory(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('current-directory', 0, _currentDirectory);
  }

  _currentDirectory(List args) {
    return interp.currentDir.path;
  }
}
