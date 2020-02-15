import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_exceptions.dart';
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

    interp.def('define', -2, _define, true);
  }

  _define(List args) async {
    final id = args[0];

    if (id is LispSym) {
      interp.globals[id] = await interp.eval(args[1], null);
      return id;
    }

    if (id is LispCell) {
      final name = id.car;
      final argList = id.cdr;
      final body = args[1];
      return id;
    }

    throw LispEvalException('unexpected id', id);
  }
}
