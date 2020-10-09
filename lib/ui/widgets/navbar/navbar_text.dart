import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';

class NavbarText extends StatelessWidget {
  NavbarText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final baseFont = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: theme.navBarActionsColor,
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
