import 'dart:async';

import 'package:custed2/core/analytics.dart';
import 'package:flutter/cupertino.dart';

class AppRoute {
  final String title;
  final Widget page;
  FutureOr Function(dynamic value) then;

  AppRoute({this.title, this.page, this.then});

  void go(BuildContext context, {bool rootNavigator = false}) {
    Analytics.recordView(title);
    final nav = Navigator.of(context, rootNavigator: rootNavigator).push(
      CupertinoPageRoute(
        title: title,
        builder: (_) => page,
      ),
    );
    if (then != null) nav.then(then);
  }

  void popup(BuildContext context, {bool useRootNavigator = true}) {
    final nav = showCupertinoModalPopup(
      context: context,
      builder: (_) => page,
      useRootNavigator: useRootNavigator,
    );
    if (then != null) nav.then(then);
  }

  void exception(e) {}
}
