import 'package:flutter/cupertino.dart';


class AppRoute {
  final String title;
  final Widget page;

  AppRoute({this.title, this.page});

  void go(BuildContext context, [bool rootNavigator = false]) {
    Navigator.of(context, rootNavigator: rootNavigator).push(
      CupertinoPageRoute(
        title: title,
        builder: (_) => page,
      ),
    );
  }

  void popup(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => page,
    );
  }

  void exception(e) {}
}