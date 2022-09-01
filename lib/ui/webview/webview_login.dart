import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/res/constants.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/ui/webview/plugin_debug.dart';
import 'package:custed2/ui/webview/plugin_login.dart';
import 'package:custed2/ui/webview/plugin_mysso.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:flutter/material.dart';

class WebviewLogin extends StatefulWidget {
  WebviewLogin({
    this.back2PrePage = true,
  });

  static Future<bool> begin(BuildContext context,
          {back2PrePage = true}) async =>
      await AppRoute(
        title: '登录(560+)',
        page: WebviewLogin(back2PrePage: back2PrePage),
      ).go(context);

  final bool back2PrePage;

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
      onLoadStop: onLoadAborted,
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
        'https://mysso.cust.edu.cn/cas/login?service=https://jwgl.cust.edu.cn/welcome',
      );
    });
  }

  void onLoadAborted(Webview2Controller controller, String url) {
    if (loginDone) {
      return;
    }

    final regExp = RegExp(r'https://jwgls\d.cust.edu.cn');
    if (url.contains(regExp)) {
      loginDone = true;
      Future.delayed(
          Duration(milliseconds: 377),
          () async => await loginSuccessCallback(
              controller, regExp.firstMatch(url).group(0)));
    }
  }

  void onLoginData(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Future<void> loginSuccessCallback(
      Webview2Controller controller, String url) async {
    final syncDomains = [
      'https://mysso.cust.edu.cn/',
      'https://mysso.cust.edu.cn/cas/login',
      'https://wwwn.cust.edu.cn/',
      'https://vpn.cust.edu.cn/',
      'https://webvpn.cust.edu.cn/',
      url,
      'https://portal.cust.edu.cn/custp/shiro-cas'
    ];

    final cookieJar = locator<PersistCookieJar>();

    for (var domain in syncDomains) {
      final cookies = await controller.getCookies(domain);
      final uri = domain.uri;
      await cookieJar.delete(uri);
      await cookieJar.saveFromResponse(uri, cookies);
    }

    final userData = await locator.getAsync<UserDataStore>();
    userData.username.put(username);
    userData.password.put(password);
    userData.lastLoginServer.put(url);

    if (!widget.back2PrePage) {
      return;
    }

    controller.evalJavascript(jwLoginPageEvalScript);

    try {
      /// 获取wengine ticket和asp net id
      await locator<JwService>().login();

      /// 登录到后端
      final cookie = await cookieJar.loadForRequest(url.uri);
      final cookieStr = buildCookie(cookie);
      if (cookieStr.isNotEmpty) {
        await CustedService().login2Backend(cookieStr, username, url);
      }

      /// 登录后的操作：获取profile、课表、成绩
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

  String buildCookie(List cookies) {
    String cookie = '';
    for (var item in cookies) {
      cookie += '${item.name}=${item.value};';
    }
    return cookie;
  }
}
