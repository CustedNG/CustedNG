import 'package:custed2/ui/theme.dart';
import 'package:flutter/cupertino.dart';

class HomeCard extends StatelessWidget {
  HomeCard({
    this.title,
    this.content,
    this.trailing,
    this.padding = 15,
  });

  final Widget title;
  final Widget content;
  final Widget trailing;
  final double padding;

  @override
  Widget build(BuildContext context) {
    // final theme = AppTheme.of(context);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withAlpha(60),
            blurRadius: 0.4,
            offset: Offset(0, 0.1),
          ),
          BoxShadow(
            color: Color(0xFF000000).withAlpha(70),
            blurRadius: 1.8,
            offset: Offset(0, 0.8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(child: _buildContent(context)),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  _buildContent(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: CupertinoColors.black
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null) _buildTitle(context),
        if (title != null) SizedBox(height: 5),
        if (content != null) DefaultTextStyle(style: textStyle, child: content),
      ],
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
