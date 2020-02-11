import 'package:custed2/core/lisp/lisp.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_util.dart';
import 'package:custed2/core/tty/command.dart';
import 'package:custed2/data/store/lisp_store.dart';
import 'package:custed2/res/build_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:custed2/core/tty/executer.dart';

class TTYEngine {
  // 1. notice banner update (presistence)
  // 2. async support
  // 3. (alice) -> alice (alias: simple form)
  // 4. set boot script

  TTYEngine(this.context) {
    _lisp.def('custed-build', 0, _custedBuild);
    _lisp.def('custed-name', 0, _custedName);
    _lisp.def('custed-set', 2, _custedSet);
    _lisp.def('custed-get', 1, _custedGet);
    _lisp.def('custed-wait', 1, _custedWait);
  }

  final BuildContext context;
  final _store = LispStore();
  final _lisp = lispMakeInterp();

  Future<void> init() async {
    await _store.init();
  }

  Future eval(String source) async {
    return _lisp.evalString(source, null);
  }

  _custedBuild(List args) {
    return BuildData.build;
  }

  _custedName(List args) {
    return BuildData.name;
  }

  _custedSet(List args) {
    final key = args[0] is int ? args[0] : args[0].toString();
    return _store.box.put(key, args[1]);
  }

  _custedGet(List args) {
    final key = args[0] is int ? args[0] : args[0].toString();
    return _store.box.get(key);
  }

  _custedWait(List args) {
    return Future.delayed(Duration(seconds: args[0]));
  }
}
