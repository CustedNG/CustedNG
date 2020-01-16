import 'package:flutter/cupertino.dart';

class AppTheme {
  AppTheme({
    this.btnPrimaryColor,
    this.navBarColor,
    this.navBarActionsColor,
    this.webviewNavBarColor,
  });

  static AppTheme bright = AppTheme(
    btnPrimaryColor: CupertinoColors.activeBlue,
    navBarColor: CupertinoColors.activeBlue,
    navBarActionsColor: CupertinoColors.white,
    webviewNavBarColor: Color(0xFF153E50),
  );

  static AppTheme dark = AppTheme(
    btnPrimaryColor: CupertinoColors.activeBlue,
    navBarColor: Color(0xFF113f67),
    navBarActionsColor: CupertinoColors.white,
    webviewNavBarColor: Color(0xFF153E50),
  );

  // 根据当前context的亮度，返回应用主题数据
  static AppTheme of(BuildContext context) {
    return CupertinoTheme.of(context).brightness == Brightness.dark
        ? dark
        : bright;
  }

  Color btnPrimaryColor;
  Color navBarColor;
  Color navBarActionsColor;
  Color webviewNavBarColor;
}
