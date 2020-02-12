import 'package:custed2/core/extension/listx.dart';
import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';
import 'package:http/http.dart' as http;

class LMCoreHttp extends LModule {
  LMCoreHttp(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('http-get', -2, _httpGet);
    interp.def('http-body', 1, _httpBody);
  }

  _httpGet(List args) async {
    final url = args[0];
    Map<String, String> headers;

    if (args[1] is LispCell) {
      final cell = (args[1] as LispCell);
      final items = cell.flatten().map((i) => i.toString()).toList();
      headers = items.toMap();
    }

    return http.get(url, headers: headers);
  }

  _httpBody(List args) async {
    final response = args[0] as http.Response;
    return response.body;
  }
}
