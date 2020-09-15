import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';

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
          style: baseFont.copyWith(fontWeight: FontWeight.normal),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
        Text(
          textBelow,
          style: baseFont.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
      ],
    );

    return Container(
      // width: 100,
      child: content,
      alignment: Alignment.center,
    );
  }
}
