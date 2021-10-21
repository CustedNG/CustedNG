import 'package:custed2/core/utils.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:flutter/material.dart';

class NavBar {
  static AppBar material(
      {@required BuildContext context,
      bool needPadding = false,
      Widget leading,
      Widget middle,
      List<Widget> trailing,
      Color backgroundColor}) {
    final primary = isDark(context)
        ? Theme.of(context).appBarTheme.backgroundColor
        : Color(locator<SettingStore>().appPrimaryColor.fetch());
    final contentColor = judgeWhiteOrBlack4AppbarContent(context);
    final contentTextStyle = TextStyle(color: contentColor);

    return AppBar(
      leading: needPadding
          ? Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: leading ?? BackIcon())
          : leading ?? BackIcon(),
      title: middle,
      centerTitle: true,
      actions: trailing,
      iconTheme: IconThemeData(color: contentColor),
      titleTextStyle: contentTextStyle,
      toolbarTextStyle: contentTextStyle,
      backgroundColor: backgroundColor ?? primary,
    );
  }
}
