import 'dart:convert';

import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';

class LMCoreJson extends LModule {
  LMCoreJson(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('json-parse', 1, _jsonParse);
    interp.def('json-dump', 1, _jsonDump);
  }

  _jsonParse(List args) {
    final jsonStr = args.first.toString();
    return json.decode(jsonStr);
  }

  _jsonDump(List args) {
    final map = args[0] as Map;
    return json.encode(map);
  }

}
