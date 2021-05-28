import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/pages/captcha_help_page.dart';
import 'package:custed2/ui/webview/plugin_debug.dart';
import 'package:custed2/ui/webview/plugin_login.dart';
import 'package:custed2/ui/webview/plugin_mysso.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:flutter/material.dart';

class WebviewLogin extends StatefulWidget {
  WebviewLogin({
    this.noLogin = false,
  });

  static Future<bool> begin(
    BuildContext context, {
    noLogin = false,
  }) async {
    final result = await AppRoute(
      title: '登录(560+)',
      page: WebviewLogin(noLogin: noLogin),
    ).go(context);
    return result == true;
  }

  final bool noLogin;

  @override
  _WebviewLoginState createState() => _WebviewLoginState();
}

class _WebviewLoginState extends State<WebviewLogin> {
  String username;
  String password;

  var loginDone = false;

  @override
  Widget build(BuildContext context) {
    return Webview2(
      onCreated: onCreated,
      onLoadAborted: onLoadAborted,
      invalidUrlRegex: r'custp\/index',
      plugins: [
        PluginForMysso(),
        PluginForLogin(onLoginData),
        PluginForDebug(),
      ],
    );
  }

  void onCreated(Webview2Controller controller) async {
    await controller.clearCookies();

    Timer(Duration(milliseconds: 500), () async {
      await controller.loadUrl(
        'https://mysso.cust.edu.cn/cas/login?service=https://portal.cust.edu.cn/custp/shiro-cas',
      );
    });

    Future.delayed(Duration(seconds: 1), () => showSnackBarWithPage(
      context, 
      '不知验证码为何物？',
      AppRoute(
        page: JwCaptchaHelpPage(),
        title: '验证码帮助'
      ),
      '点我查看'
    ));
  }

  void onLoadAborted(Webview2Controller controller, String url) async {
    if (loginDone) {
      return;
    }

    if (url.contains('portal.cust.edu.cn')) {
      loginDone = true;
      await loginSuccessCallback(controller);
    }
  }

  void onLoginData(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Future<void> loginSuccessCallback(Webview2Controller controller) async {
    const syncDomains = [
      'https://mysso.cust.edu.cn/',
      'https://mysso.cust.edu.cn/cas/login',
      'https://wwwn.cust.edu.cn/',
      'https://vpn.cust.edu.cn/',
      'https://webvpn.cust.edu.cn/',
    ];

    final cookieJar = locator<PersistCookieJar>();

    for (var domain in syncDomains) {
      final cookies = await controller.getCookies(domain);
      await cookieJar.delete(Uri.parse(domain));
      await cookieJar.saveFromResponse(Uri.parse(domain), cookies);
    }

    final userData = await locator.getAsync<UserDataStore>();
    userData.username.put(this.username);
    userData.password.put(this.password);

    if (widget.noLogin) {
      return;
    }

    try {
      final user = locator<UserProvider>();
      await user.login();
      showSnackBar(context, '登录成功');
    } catch (e) {
      showSnackBar(context, '登录出错啦 等下再试吧');
      rethrow;
    }

    await controller.close();
    Navigator.of(context).pop(true);
  }
}
