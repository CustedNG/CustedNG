import 'dart:convert';

import 'package:custed2/core/lisp/lisp_exceptions.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp/lisp_sym.dart';
import 'package:custed2/core/lisp_module/module.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/locator.dart';
import 'package:flutter/widgets.dart';

class LMUI extends LModule {
  LMUI(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    await interp.require('ui/store');
    await interp.require('ui/widget');
    interp.def('view', 1, _view);
    interp.def('view-pop', 0, _viewPop);
  }

  _view(List args) {
    // final contextVarList = ['custed-context', '*context*'];
    // final avaliableContextKey = contextVarList
    //     .map((key) => LispSym(key))
    //     .firstWhere((key) => interp.globals.containsKey(key),
    //         orElse: () => null);

    // if (avaliableContextKey == null) {
    //   throw LispEvalException('no avaliable context', contextVarList);
    // }

    // final context = interp.globals[avaliableContextKey] as BuildContext;
    // AppRoute(title: 'LispView', page: widget).go(context, rootNavigator: true);

    final ctx = locator<GlobalKey<NavigatorState>>().currentState.overlay.context;
    final widget = args[0];
    AppRoute(title: 'LispView', page: widget).go(ctx, rootNavigator: true);
  }

  _viewPop(List args) {
    final ctx = locator<GlobalKey<NavigatorState>>().currentState.overlay.context;
    Navigator.pop(ctx);
  }
}
