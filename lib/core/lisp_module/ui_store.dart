import 'dart:async';

import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_func.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';
import 'package:flutter/widgets.dart';

class LMUIStore extends LModule {
  LMUIStore(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('store-new', 0, _storeNew);
    interp.def('store-add', -2, _storeAdd);
    interp.def('store-listen', 2, _storeListen);
  }

  _storeNew(List args) {
    final store = StreamController.broadcast();
    return store;
  }

  _storeAdd(List args) {
    final store = args[0] as StreamController;
    final data = args[1];
    return store.sink.add(data);
  }

  _storeListen(List args) {
    final store = args[0] as StreamController;
    final onData = args[1] as LispFunc;
    return StreamBuilder(
      stream: store.stream,
      builder: (context, snapshot) {
        print(snapshot.data);
        return FutureBuilder(
          future: interp.eval(LispCell.from([onData, snapshot.data, null]), null),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData ? snapshot.data : Container();
          },
        );
      },
    );
  }
}
