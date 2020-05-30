import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DarkModeFilter extends StatelessWidget {
  DarkModeFilter({this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    if (!isDark) {
      return child;
    }

    return ColorFiltered(
      child: child,
      colorFilter: ColorFilter.mode(Color(0xFFcccccc), BlendMode.modulate),
    );
  }
}
