import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_func.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';
import 'package:flutter/cupertino.dart';

class LMUIWidget extends LModule {
  LMUIWidget(LispInterp interp) : super(interp);

  Future<void> load() async {
    await interp.require('core/base');
    interp.def('text', 1, _text);
    interp.def('page', 2, _page);
    interp.def('center', 1, _center);
    interp.def('button', 2, _button);
    interp.def('column', 1, _column);
    interp.def('row', 1, _row);
  }

  _page(List args) {
    final title = args[0]?.toString() ?? '';
    final widget = args[1];
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(title)),
      child: SafeArea(child: widget),
    );
  }

  _text(List args) {
    final text = args.first.toString();
    return Text(text);
  }

  _center(List args) {
    final child = args[0] as Widget;
    return Center(child: child);
  }

  _button(List args) async {
    final child = args[0] is Widget ? args[0] : Text(args[0].toString());
    final onClick = LispCell(args[1], null);
    return CupertinoButton(
      child: child,
      onPressed: () => interp.eval(onClick, null),
    );
  }

  _column(List args) {
    final children = List<Widget>.from((args[0] as LispCell).flatten());
    return Column(
      children: children,
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  _row(List args) {
    final children = List<Widget>.from((args[0] as LispCell).flatten());
    return Row(children: children);
  }
}
