import 'package:custed2/core/lisp/lisp_cell.dart';
import 'package:custed2/core/lisp/lisp_frame.dart';
import 'package:custed2/core/lisp/lisp_interp.dart';
import 'package:custed2/core/lisp_module/module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

class LMUIWidget extends LModule {
  LMUIWidget(LispInterp interp) : super(interp);

  static const source = '''
(defun h1 (txt) (text txt #:size 40 #:weight 'bold))
(defun h2 (txt) (text txt #:size 36 #:weight 'bold))
(defun h3 (txt) (text txt #:size 32 #:weight 'bold))
(defun h4 (txt) (text txt #:size 28 #:weight 'bold))
(defun h5 (txt) (text txt #:size 24 #:weight 'bold))
(defun h6 (txt) (text txt #:size 20 #:weight 'bold))
  ''';

  Future<void> load() async {
    await interp.require('core/base');
    await interp.evalString(source, null);

    interp.def('text', 1, _text);
    interp.def('page', 2, _page);
    interp.def('center', 1, _center);
    interp.def('button', 2, _button);
    interp.def('column', 1, _column);
    interp.def('row', 1, _row);
    interp.def('sizedbox', 0, _sizedbox);
    interp.def('padding', 1, _padding);
    interp.def('listview', 1, _listview);
    interp.def('image', 1, _image);
  }

  _page(List args) {
    final title = args[0]?.toString() ?? '';
    final widget = args[1];
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(child: widget),
    );
  }

  _text(LispFrame frame) {
    const fontWeightMap = {
      'w100': FontWeight.w100,
      'w200': FontWeight.w200,
      'w300': FontWeight.w300,
      'w400': FontWeight.w400,
      'w500': FontWeight.w500,
      'w600': FontWeight.w600,
      'w700': FontWeight.w700,
      'w800': FontWeight.w800,
      'w900': FontWeight.w900,
      'normal': FontWeight.w400,
      'bold': FontWeight.w700,
    };
    final text = frame.positioned.first.toString();
    final style = TextStyle(
      fontSize: frame.keyword['size']?.toDouble(),
      fontWeight: fontWeightMap[frame.keyword['weight']?.toString()],
    );
    return Text(text, style: style);
  }

  _center(List args) {
    final child = args[0] as Widget;
    return Center(child: child);
  }

  _button(LispFrame frame) async {
    final child = frame[0] is Widget ? frame[0] : Text(frame[0].toString());
    final onClick = LispCell(frame[1], null);
    final padding = frame.keyword['padding']?.toDouble();
    return CupertinoButton(
      padding: padding == null ? null : EdgeInsets.all(padding),
      child: child,
      onPressed: () => interp.eval(onClick, null),
    );
  }

  _column(LispFrame frame) {
    final children = List<Widget>.from((frame[0] as LispCell).flatten());
    final align = frame.keyword['align'].toString() == 'center'
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    return Column(
      children: children,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
    );
  }

  _row(List args) {
    final children = List<Widget>.from((args[0] as LispCell).flatten());
    return Row(children: children);
  }

  _sizedbox(LispFrame frame) {
    final height = frame.keyword['height']?.toDouble();
    final width = frame.keyword['width']?.toDouble();
    return SizedBox(height: height, width: width);
  }

  _padding(LispFrame frame) {
    final child = frame.positioned[0] as Widget;
    EdgeInsets padding;
    if (frame.keyword.containsKey('all')) {
      final all = frame.keyword['all']?.toDouble() ?? 0.0;
      padding = EdgeInsets.all(all);
    } else {
      final top = frame.keyword['top']?.toDouble() ?? 0.0;
      final bottom = frame.keyword['bottom']?.toDouble() ?? 0.0;
      final left = frame.keyword['left']?.toDouble() ?? 0.0;
      final right = frame.keyword['right']?.toDouble() ?? 0.0;
      padding = EdgeInsets.fromLTRB(left, top, right, bottom);
    }
    return Padding(child: child, padding: padding);
  }

  _listview(LispFrame frame) {
    final child = frame.positioned[0] as Widget;
    final single = frame.keyword['single'] == true;
    return single
        ? SingleChildScrollView(child: child)
        : ListView(children: <Widget>[child]);
  }

  _image(LispFrame frame) {
    final url = frame.positioned[0].toString();
    final width = frame.keyword['width']?.toDouble();

    return TransitionToImage(
      width: width,
      loadingWidget: Container(
        child: Center(child: CircularProgressIndicator()),
        width: 100,
        height: 100,
      ),
      placeholder: Container(
        child: Center(child: Icon(Icons.refresh)),
        width: 100,
        height: 100,
      ),
      enableRefresh: true,
      image: AdvancedNetworkImage(url),
    );
  }
}
