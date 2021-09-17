import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ColorX on Color {
  bool get isBrightColor {
    if (getBrightnessFromColor == Brightness.light) {
      return true;
    }
    return false;
  }

  SystemUiOverlayStyle get systemOverlayStyle =>
      isBrightColor ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;

  Brightness get getBrightnessFromColor {
    return ThemeData.estimateBrightnessForColor(this);
  }
}
