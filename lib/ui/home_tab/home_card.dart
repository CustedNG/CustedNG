import 'package:custed2/ui/theme.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  HomeCard({
    this.title,
    this.content,
    this.trailing,
    this.padding = 15,
    this.borderRadius = 7
  });

  final Widget title;
  final Widget content;
  final Widget trailing;
  final double padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return Card(
        color: theme.cardBackgroundColor,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        clipBehavior: Clip.antiAlias,
        semanticContainer: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(child: _buildContent(context)),
              if (trailing != null) trailing,
              if (trailing != null) SizedBox(width: 7),
            ],
          ),
        )
    );
  }

  _buildContent(BuildContext context) {
    final theme = AppTheme.of(context);
    final textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: theme.cardTextColor,
    );

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (title != null) _buildTitle(context),
          if (title != null) SizedBox(height: 5),
          if (content != null) DefaultTextStyle(style: textStyle, child: content),
        ],
      ),
    );
  }

  _buildTitle(BuildContext context) {
    final theme = AppTheme.of(context);

    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: theme.textColor.withAlpha(220),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        DefaultTextStyle(child: title, style: textStyle),
      ],
    );
  }
}
