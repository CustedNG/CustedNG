import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:flutter/cupertino.dart';

class HomeEntry extends StatelessWidget {
  HomeEntry({this.name, this.icon, this.action, this.longPressAction});

  final Widget name;
  final Widget icon;
  final void Function() action;
  final void Function() longPressAction;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final textStyle = TextStyle(
      fontSize: 13,
      color: theme.textColor.withAlpha(220),
    );

    return GestureDetector(
      onLongPress: longPressAction,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: action ?? () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            SizedBox(height: 30, child: DarkModeFilter(child: icon)),
            SizedBox(height: 10),
            DefaultTextStyle(child: name, style: textStyle),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
