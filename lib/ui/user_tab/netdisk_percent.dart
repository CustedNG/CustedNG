import 'package:flutter/cupertino.dart';

class NetdiskPercent extends StatelessWidget {
  NetdiskPercent(this.value, this.total, {this.height = 12});

  final int total;
  final int value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final left = Container(
      color: CupertinoColors.activeBlue.withOpacity(0.8),
      height: height,
    );
    final right = Container(
      color: CupertinoColors.lightBackgroundGray,
      height: height,
    );
    return Row(
      children: <Widget>[
        Flexible(flex: value, child: left),
        Flexible(flex: total - value, child: right),
      ],
    );
  }
}
