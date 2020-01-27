import 'package:custed2/config/theme.dart';
import 'package:flutter/cupertino.dart';

class PlaceholderWidget extends StatelessWidget {
  PlaceholderWidget({
    this.text,
    this.isActive = false,
    this.light = false,
  });

  final String text;
  final bool isActive;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: light ? FontWeight.normal : FontWeight.bold,
      color: theme.lightTextColor,
    );

    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isActive) CupertinoActivityIndicator(),
            if (isActive) SizedBox(height: 10),
            Text(
              text ?? defaultText,
              style: textStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String get defaultText => isActive ? '加载中...' : '施工中...';
}
