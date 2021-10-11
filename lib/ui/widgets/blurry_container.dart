// a edition of https://github.com/ranjeetrocky/blurry_container/blob/master/lib/blurrycontainer.dart

import 'dart:ui';

import 'package:flutter/material.dart';

const double kBlur = 1.0;
const EdgeInsetsGeometry kDefaultPadding = EdgeInsets.all(16);
const Color kDefaultColor = Colors.transparent;
const BorderRadius kBorderRadius = BorderRadius.zero;
const double kColorOpacity = 1.0;

class BlurryContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double height, width;
  final EdgeInsetsGeometry padding;
  final Color bgColor;
  final double colorOpacity;

  final BorderRadius borderRadius;

  //final double colorOpacity;

  BlurryContainer({
    this.child,
    this.blur = 5,
    @required this.height,
    @required this.width,
    this.padding = kDefaultPadding,
    this.bgColor = kDefaultColor,
    this.borderRadius = kBorderRadius,
    this.colorOpacity = kColorOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          color: bgColor == Colors.transparent
              ? bgColor
              : bgColor.withOpacity(colorOpacity),
          child: child ?? SizedBox(),
        ),
      ),
    );
  }
}
