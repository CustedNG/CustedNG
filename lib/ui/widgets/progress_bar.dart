import 'package:flutter/cupertino.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar(
    this.value,
    this.total, {
    this.borderWidth = 0,
    this.bgColor = CupertinoColors.lightBackgroundGray,
  });

  final int value;
  final int total;
  final double borderWidth;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final left = Container(color: CupertinoColors.activeBlue);
    final right = Container(color: bgColor);
    final bar = Row(
      children: <Widget>[
        Flexible(flex: value ?? 0, child: left),
        Flexible(flex: (total - value) ?? 1, child: right),
      ],
    );
    return Container(
      child: bar,
      decoration: BoxDecoration(border: buildBorder()),
    );
  }

  BoxBorder buildBorder() {
    if (borderWidth == 0) {
      return null;
    }

    return Border.all(
      color: CupertinoColors.black.withAlpha(60),
      width: borderWidth,
    );
  }
}
