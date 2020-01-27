import 'package:custed2/config/theme.dart';
import 'package:flutter/cupertino.dart';

class HomeEntry extends StatelessWidget {
  HomeEntry({this.name, this.icon, this.action});

  final Widget name;
  final Widget icon;
  final void Function() action;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final textStyle = TextStyle(
      fontSize: 13,
      color: theme.textColor.withAlpha(220),
    );

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: action ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          SizedBox(height: 30, child: icon),
          SizedBox(height: 10),
          DefaultTextStyle(child: name, style: textStyle),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
