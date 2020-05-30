import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DarkModeFilter extends StatelessWidget {
  DarkModeFilter({this.child, this.level = 200});

  final Widget child;
  final int level;
  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.of(context).brightness == Brightness.dark;

    if (!isDark) {
      return child;
    }

    return ColorFiltered(
      child: child,
      colorFilter: ColorFilter.mode(
        Color.fromARGB(255, level, level, level),
        BlendMode.modulate,
      ),
    );
  }
}
