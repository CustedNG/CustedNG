import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';

class NavbarMiddle extends StatelessWidget {
  NavbarMiddle({
    this.textAbove,
    this.textBelow,
  });

  final String textAbove;
  final String textBelow;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    final baseFont = TextStyle(
      fontSize: 12,
      color: theme.navBarActionsColor,
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          textAbove,
          style: baseFont.copyWith(fontWeight: FontWeight.normal),
        ),
        Text(
          textBelow,
          style: baseFont.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );

    return Container(
      width: 100,
      child: content,
      alignment: Alignment.center,
    );
  }
}
