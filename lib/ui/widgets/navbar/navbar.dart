import 'package:custed2/config/theme.dart';
import 'package:flutter/cupertino.dart';

class NavBar {
  static CupertinoNavigationBar cupertino({
    BuildContext context,
    Widget leading,
    Widget middle,
    Widget trailing,
  }) {
    final theme = AppTheme.of(context);

    return CupertinoNavigationBar(
      backgroundColor: theme.navBarColor,
      actionsForegroundColor: theme.navBarActionsColor,
      leading: leading,
      middle: middle,
      trailing: trailing,
    );
  }
}
