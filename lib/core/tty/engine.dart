import 'package:flutter/widgets.dart';

class TTYEngine {
  TTYEngine();

  BuildContext _context;
  bool _inited = false;

  Future<void> init() async {
    if (_inited) {
      return;
    }

    _setupFunctions();
    _inited = true;
  }

  void _setupFunctions() {
    // Reference: https://docs.racket-lang.org/racket-cheat/index.html
    // _lisp.def('cookie-delete', 1, _cookieSet);
    // _lisp.def('cookie-delete-all', 0, _cookieSet);
  }

  Future eval(String source) async {
  }

  void setContext(BuildContext context) {
    _context = context;
  }
}
