import 'package:flutter/material.dart';

class NavbarText extends StatelessWidget {
  NavbarText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final baseFont = TextStyle(
      fontSize: 15.777,
      fontWeight: FontWeight.bold,
    );

    return Text(
      text,
      textScaleFactor: 1.0,
      style: baseFont,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}
