import 'package:custed2/ui/theme.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

class DynamicColor {
  const DynamicColor(this.light, this.dark);

  final Color light;
  final Color dark;

  resolve(BuildContext context) {
    return isDark(context) ? dark : light;
  }
}
