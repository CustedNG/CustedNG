import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class DynamicColor {
  const DynamicColor(this.light, this.dark);

  final Color light;
  final Color dark;

  resolve(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    return isDark ? dark : light;
  }
}
