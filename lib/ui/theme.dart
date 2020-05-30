import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;

// should be material.Theme.of(context).backgroundColor
// scheduleButtonColor: Color(0xFFF0EFF3),

final _appTheme = AppTheme();

enum DarkMode {
  on,
  off,
  auto,
}

class AppTheme {
  static AppThemeResolved bright = resolve(Brightness.light);

  static AppThemeResolved dark = resolve(Brightness.dark);

  // 根据当前context的亮度，返回应用主题数据
  static AppThemeResolved of(BuildContext context) {
    return CupertinoTheme.of(context).brightness == Brightness.dark
        ? dark
        : bright;
  }

  // 根据当前context的亮度，返回应用主题数据
  static AppThemeResolved resolve(Brightness brightness) {
    return AppThemeResolved()
      ..primaryColor = s(brightness, _appTheme.primaryColor)
      ..btnPrimaryColor = s(brightness, _appTheme.btnPrimaryColor)
      ..navBarColor = s(brightness, _appTheme.navBarColor)
      ..navBarActionsColor = s(brightness, _appTheme.navBarActionsColor)
      ..webviewNavBarColor = s(brightness, _appTheme.webviewNavBarColor)
      ..textColor = s(brightness, _appTheme.textColor)
      ..lightTextColor = s(brightness, _appTheme.lightTextColor)
      ..scheduleOutlineColor = s(brightness, _appTheme.scheduleOutlineColor)
      ..scheduleButtonColor = s(brightness, _appTheme.scheduleButtonColor)
      ..scheduleButtonTextColor =
          s(brightness, _appTheme.scheduleButtonTextColor)
      ..scheduleTextColor = s(brightness, _appTheme.scheduleTextColor);
  }

  static Color s(Brightness brightness, CupertinoDynamicColor color) {
    return brightness == Brightness.dark ? color.darkColor : color.color;
  }

  final primaryColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.activeBlue,
    darkColor: CupertinoColors.activeBlue,
  );

  final btnPrimaryColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.activeBlue,
    darkColor: CupertinoColors.activeBlue,
  );

  final navBarColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.activeBlue,
    darkColor: Color(0xFF113f67),
  );

  final navBarActionsColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.white,
  );

  final webviewNavBarColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF153E50),
    darkColor: Color(0xFF153E50),
  );

  final textColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );

  final lightTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF8A8A8A),
    darkColor: Color(0xFF8A8A8A),
  );

  final scheduleOutlineColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE7ECEb),
    darkColor: material.Colors.grey[800],
  );

  final scheduleButtonColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF0EFF3),
    darkColor: Color(0xFFF0EFF3),
  );

  final scheduleButtonTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF83868E),
    darkColor: Color(0xFF83868E),
  );

  final scheduleTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF898C91),
    darkColor: Color(0xFF898C91),
  );
}

class AppThemeResolved {
  Color primaryColor;
  Color btnPrimaryColor;
  Color navBarColor;
  Color navBarActionsColor;
  Color webviewNavBarColor;
  Color textColor;
  Color lightTextColor;
  Color scheduleOutlineColor;
  Color scheduleButtonColor;
  Color scheduleButtonTextColor;
  Color scheduleTextColor;
}
