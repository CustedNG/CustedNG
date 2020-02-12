import 'package:custed2/core/extension/listx.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LMCoreHash extends LModule {
  LMCoreHash(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('hash', -1, _hash);
    interp.def('hash-ref', 2, _hashRef);
    interp.def('hash-set', 3, _hashSetFunctional);
    interp.def('hash-set!', 3, _hashSet);
  }

  _hash(List args) {
    final items = (args.first as LispCell).flatten();
    return items.toMap();
  }

  _hashRef(List args) {
    final map = args[0] as Map;
    final key = args[1];
    return map[key];
  }

  _hashSetFunctional(List args) {
    final map = args[0] as Map;
    final key = args[1];
    final val = args[2];
    final result =  Map.from(map);
    result[key] = val;
    return result;
  }

  _hashSet(List args) {
    final map = args[0] as Map;
    final key = args[1];
    final val = args[2];
    map[key] = val;
    return val;
  }

}
