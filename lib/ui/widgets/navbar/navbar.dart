import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:flutter/material.dart';

class NavBar {
  static AppBar material({
    BuildContext context,
    bool needPadding = false,
    Widget leading,
    Widget middle,
    List<Widget> trailing,
    Color backgroundColor
  }) {

    return AppBar(
      leading: needPadding
          ? Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: leading ?? BackIcon()
          )
          : leading ?? BackIcon(),
      title: middle,
      centerTitle: true,
      actions: trailing,
      brightness: Brightness.dark,
      backgroundColor: backgroundColor,
    );
  }
}
