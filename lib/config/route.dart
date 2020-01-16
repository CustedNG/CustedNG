import 'package:custed2/ui/pages/debug_page.dart';
import 'package:custed2/ui/pages/login_page.dart';
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

final loginPage = AppRoute(
  title: '登录',
  page: LoginPage(),
);

final debugPage = AppRoute(
  title: '终端',
  page: DebugPage(),
);
