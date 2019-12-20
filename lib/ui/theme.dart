import 'package:flutter/cupertino.dart';

class AppTheme {
  AppTheme({
    this.navBarColor,
    this.navBarActionsColor,
  });

  static AppTheme bright = AppTheme(
    navBarColor: CupertinoColors.activeBlue,
    navBarActionsColor: CupertinoColors.white,
  );

  static AppTheme dart = AppTheme(
    navBarColor: Color(0xFF113f67),
    navBarActionsColor: CupertinoColors.white,
  );

  static AppTheme of(BuildContext context) {
    return CupertinoTheme.of(context).brightness == Brightness.dark
        ? dart
        : bright;
  }

  Color navBarColor;
  Color navBarActionsColor;
}
