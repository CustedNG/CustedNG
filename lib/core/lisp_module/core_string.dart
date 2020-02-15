import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_frame.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LMCoreString extends LModule {
  LMCoreString(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('string-join', -1, _stringJoin);
  }

  _stringJoin(LispFrame frame) {
    final sep = frame.keyword['sep'] ?? '';
    final strings = (frame[0] as LispCell).flatten().map((e) => e.toString());
    return strings.join(sep);
  }
}
