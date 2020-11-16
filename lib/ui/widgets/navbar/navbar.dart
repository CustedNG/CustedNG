import 'package:custed2/ui/theme.dart';
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
      brightness: Brightness.dark,
      leading: leading,
      middle: middle,
      trailing: trailing,
    );
  }
}
