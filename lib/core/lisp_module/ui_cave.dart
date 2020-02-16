import 'dart:async';

import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';
import 'package:flutter/widgets.dart';

class _Cave extends StatelessWidget {
  _Cave(this.initPage);

  final Widget initPage;
  final stream = StreamController<Widget>.broadcast();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: initPage,
      stream: stream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) return snapshot.data;
        return Container();
      },
    );
  }
}

class LMUICave extends LModule {
  LMUICave(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('cave', 1, _cave);
    interp.def('cave-put', 2, _cavePut);
  }

  _cave(List args) {
    final widget = args[0] as Widget;
    return _Cave(widget);
  }

  _cavePut(List args) {
    final cave = args[0] as _Cave;
    final widget = args[1] as Widget;
    return cave.stream.sink.add(widget);
  }
}
