import 'package:custed2/core/util/build_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, Theme;

// should be material.Theme.of(context).backgroundColor
// scheduleButtonColor: Color(0xFFF0EFF3),

final _appTheme = AppTheme();

bool isDark(BuildContext context) {
  return CupertinoTheme.of(context).brightness == Brightness.dark;
}

class DarkMode {
  static const auto = 0;
  static const on = 1;
  static const off = 2;
}

class AppTheme {
  static AppThemeResolved bright = resolve(Brightness.light);

  static AppThemeResolved dark = resolve(Brightness.dark);

  // 根据当前context的亮度，返回应用主题数据
  static AppThemeResolved of(BuildContext context) {
    if (BuildMode.isDebug) {
      return resolve(Theme.of(context).brightness);
    }

    return isDark(context) ? dark : bright;
  }

  // 根据当前context的亮度，返回应用主题数据
  static AppThemeResolved resolve(Brightness brightness) {
    return AppThemeResolved()
      ..primaryColor = s(brightness, _appTheme.primaryColor)
      ..secondaryHeaderColor = s(brightness, _appTheme.secondaryHeaderColor)
      ..backgroundColor = s(brightness, _appTheme.backgroundColor)
      ..btnPrimaryColor = s(brightness, _appTheme.btnPrimaryColor)
      ..navBarColor = s(brightness, _appTheme.navBarColor)
      ..navBarActionsColor = s(brightness, _appTheme.navBarActionsColor)
      ..webviewNavBarColor = s(brightness, _appTheme.webviewNavBarColor)
      ..textColor = s(brightness, _appTheme.textColor)
      ..textColorInversed = s(brightness, _appTheme.textColorInversed)
      ..lightTextColor = s(brightness, _appTheme.lightTextColor)
      ..scheduleOutlineColor = s(brightness, _appTheme.scheduleOutlineColor)
      ..scheduleButtonColor = s(brightness, _appTheme.scheduleButtonColor)
      ..scheduleBackgroundColor =
          s(brightness, _appTheme.scheduleBackgroundColor)
      ..scheduleButtonTextColor =
          s(brightness, _appTheme.scheduleButtonTextColor)
      ..scheduleTextColor = s(brightness, _appTheme.scheduleTextColor)
      ..cardBackgroundColor = s(brightness, _appTheme.cardBackgroundColor)
      ..cardTextColor = s(brightness, _appTheme.cardTextColor)
      ..homeBackgroundColor = s(brightness, _appTheme.homeBackgroundColor)
      ..textFieldBackgroundColor =
          s(brightness, _appTheme.textFieldBackgroundColor)
      ..textFieldBorderColor = s(brightness, _appTheme.textFieldBorderColor)
      ..textFieldListBackgroundColor =
          s(brightness, _appTheme.textFieldListBackgroundColor);
  }

  static Color s(Brightness brightness, CupertinoDynamicColor color) {
    return brightness == Brightness.dark ? color.darkColor : color.color;
  }

  final primaryColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.activeBlue,
    darkColor: CupertinoColors.activeBlue,
  );

  final secondaryHeaderColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF3D93F8),
    darkColor: Color(0xFF264f70),
  );

  final backgroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.darkBackgroundGray,
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

  final textColorInversed = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  );

  final lightTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF8A8A8A),
    darkColor: Color(0xFF8A8A8A),
  );

  final scheduleOutlineColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE7ECEb),
    darkColor: Colors.grey[850],
  );

  final scheduleButtonColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF0EFF3),
    darkColor: Color(0xFF2F2F2F),
  );

  final scheduleBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.darkBackgroundGray,
  );

  final scheduleButtonTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF83868E),
    darkColor: Color(0xFF83868E),
  );

  final scheduleTextColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF898C91),
    darkColor: Color(0xFF898C91),
  );

  final cardBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: Colors.grey[850],
  );

  final cardTextColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: Colors.white70,
  );

  final homeBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFEFEFE),
    darkColor: CupertinoColors.darkBackgroundGray,
  );

  final textFieldBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: Colors.transparent,
  );

  final textFieldBorderColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.lightBackgroundGray,
    darkColor: Colors.grey[850],
  );

  final textFieldListBackgroundColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.lightBackgroundGray,
    darkColor: CupertinoColors.darkBackgroundGray,
  );
}

class AppThemeResolved {
  Color primaryColor;
  Color secondaryHeaderColor;
  Color backgroundColor;
  Color btnPrimaryColor;
  Color navBarColor;
  Color navBarActionsColor;
  Color webviewNavBarColor;
  Color textColor;
  Color textColorInversed;
  Color lightTextColor;
  Color scheduleOutlineColor;
  Color scheduleButtonColor;
  Color scheduleBackgroundColor;
  Color scheduleButtonTextColor;
  Color scheduleTextColor;
  Color cardBackgroundColor;
  Color cardTextColor;
  Color homeBackgroundColor;
  Color textFieldBackgroundColor;
  Color textFieldBorderColor;
  Color textFieldListBackgroundColor;
}
