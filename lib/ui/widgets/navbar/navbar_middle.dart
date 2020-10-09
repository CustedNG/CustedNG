import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';

class NavbarMiddle extends StatelessWidget {
  NavbarMiddle({
    this.textAbove,
    this.textBelow,
    this.colorOverride,
  });

  final String textAbove;
  final String textBelow;
  final Color colorOverride;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final baseFont = TextStyle(
      fontSize: 12,
      color: colorOverride ?? theme.navBarActionsColor,
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          textAbove,
          textScaleFactor: 1.0,
          style: baseFont.copyWith(fontWeight: FontWeight.normal),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
        Text(
          textBelow,
          textScaleFactor: 1.0,
          style: baseFont.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
      ],
    );

    return Container(
      width: 120,
      child: content,
      alignment: Alignment.center,
    );
  }
}
