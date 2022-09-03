import 'package:custed2/core/provider/provider_base.dart';
import 'package:flutter/material.dart';

final headReg = RegExp(r'(\[[A-Z]+\])( .*)');

class DebugProvider extends ProviderBase {
  final widgets = <Widget>[];

  void addText(String text) {
    final match = headReg.allMatches(text);

    if (match.isNotEmpty) {
      addWidget(Text.rich(TextSpan(
        children: [
          TextSpan(
            text: match.first.group(1),
            style: TextStyle(color: Colors.cyan),
          ),
          TextSpan(
            text: match.first.group(2),
          )
        ],
      )));
    } else {
      _addText(text);
    }

    notifyListeners();
  }

  void _addText(String text) {
    _addWidget(Text(text));
  }

  void addError(Object error) {
    _addError(error);
    notifyListeners();
  }

  void _addError(Object error) {
    _addMultiline(error, Colors.red);
  }

  void addMultiline(Object data, [Color color = Colors.blue]) {
    _addMultiline(data, color);
    notifyListeners();
  }

  void _addMultiline(Object data, [Color color = Colors.blue]) {
    final widget = Text(
      '$data',
      style: TextStyle(
        color: color,
      ),
    );
    _addWidget(SingleChildScrollView(
      child: widget,
      scrollDirection: Axis.horizontal,
    ));
  }

  void addWidget(Widget widget) {
    _addWidget(widget);
    notifyListeners();
  }

  void _addWidget(Widget widget) {
    final outlined = Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
        ),
      ),
      child: widget,
    );

    widgets.add(outlined);
  }

  void clear() {
    widgets.clear();
    notifyListeners();
  }
}
