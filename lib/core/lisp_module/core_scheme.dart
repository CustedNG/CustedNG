import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LMCoreScheme extends LModule {
  LMCoreScheme(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    await interp.require('core/http');
    await interp.require('core/hash');
    await interp.require('core/json');
    await interp.require('core/string');
    await interp.require('core/directory');

    interp.globals[LispSym('#t')] = true;
    interp.globals[LispSym('#f')] = false;
  }
}
