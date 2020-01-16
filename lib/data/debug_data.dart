import 'package:flutter/cupertino.dart';

class DebugData {
  final widgets = <Widget>[];

  addText(String text) {
    addWidget(Text(text));
  }

  addError(Object error) {
    final widget = Text(
      '$error',
      style: TextStyle(
        color: CupertinoColors.destructiveRed,
      ),
    );
    addWidget(SingleChildScrollView(
      child: widget,
      scrollDirection: Axis.horizontal,
    ));
  }

  addWidget(Widget widget) {
    final outlined = Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.activeGreen,
        ),
      ),
      child: widget,
    );

    widgets.add(outlined);
  }
}
