import 'package:custed2/core/analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRoute {
  final String title;
  final Widget page;

  AppRoute({this.title, this.page});

  void go(BuildContext context, {bool rootNavigator = false}) {
    Analytics.recordView(title);
    Navigator.of(context, rootNavigator: rootNavigator).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  void exception(e) {}
}
