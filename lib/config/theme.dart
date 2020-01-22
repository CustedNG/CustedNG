import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

class AppTheme {
  const AppTheme({
    this.btnPrimaryColor,
    this.navBarColor,
    this.navBarActionsColor,
    this.webviewNavBarColor,
    this.textColor,
    this.lightTextColor,
    this.scheduleOutlineColor,
    this.scheduleButtonColor,
    this.scheduleButtonTextColor,
    this.scheduleTextColor,
  });

  static AppTheme bright = AppTheme(
    btnPrimaryColor: CupertinoColors.activeBlue,
    navBarColor: CupertinoColors.activeBlue,
    navBarActionsColor: CupertinoColors.white,
    webviewNavBarColor: Color(0xFF153E50),
    textColor: CupertinoColors.black,
    lightTextColor: Color(0xFF8A8A8A),
    scheduleOutlineColor: Color(0xFFE7ECEb),
    scheduleButtonColor: Color(0xFFF0EFF3),
    scheduleButtonTextColor: Color(0xFF83868E),
    scheduleTextColor: Color(0xFF898C91),
  );

  static AppTheme dark = AppTheme(
    btnPrimaryColor: CupertinoColors.activeBlue,
    navBarColor: Color(0xFF113f67),
    navBarActionsColor: CupertinoColors.white,
    webviewNavBarColor: Color(0xFF153E50),
    textColor: CupertinoColors.white,
    lightTextColor: Color(0xFF8A8A8A),
    scheduleOutlineColor: material.Colors.grey[800],
    // should be material.Theme.of(context).backgroundColor
    scheduleButtonColor: Color(0xFFF0EFF3),
    scheduleButtonTextColor: Color(0xFF83868E),
    scheduleTextColor: Color(0xFF898C91),
  );

  // 根据当前context的亮度，返回应用主题数据
  static AppTheme of(BuildContext context) {
    return CupertinoTheme.of(context).brightness == Brightness.dark
        ? dark
        : bright;
  }

  final Color btnPrimaryColor;
  final Color navBarColor;
  final Color navBarActionsColor;
  final Color webviewNavBarColor;
  final Color textColor;
  final Color lightTextColor;
  final Color scheduleOutlineColor;
  final Color scheduleButtonColor;
  final Color scheduleButtonTextColor;
  final Color scheduleTextColor;
}
