import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ColorX on Color {
  bool get isBrightColor {
    return getBrightnessFromColor == Brightness.light;
  }

  SystemUiOverlayStyle get systemOverlayStyle =>
      isBrightColor ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;

  Brightness get getBrightnessFromColor {
    return ThemeData.estimateBrightnessForColor(this);
  }
}
