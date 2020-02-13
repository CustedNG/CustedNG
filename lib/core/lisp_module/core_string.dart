import 'dart:convert';

import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_util.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LMCoreString extends LModule {
  LMCoreString(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('string-join', -2, _stringJoin);
  }

  _stringJoin(List args) {
    final strings = (args[0] as LispCell).flatten().map((e) => e.toString());
    final sep = (args[1] is LispCell) ? args[1].car.toString() : '';
    return strings.join(sep);
  }
}
