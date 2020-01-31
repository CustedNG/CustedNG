import 'dart:convert';

import 'package:custed2/config/theme.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final channel = 'LoginChannel';

  WebViewController controller;
  bool isBusy = false;

  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: theme.webviewNavBarColor,
        actionsForegroundColor: theme.navBarActionsColor,
        middle: Text(
          '登录',
          style: TextStyle(color: theme.navBarActionsColor),
        ),
        trailing: isBusy ? _buildIndicator(context) : null,
      ),
      child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: {
          JavascriptChannel(
            name: channel,
            onMessageReceived: (msg) {
              final data = json.decode(msg.message);
              print(data);
              username = data['username'];
              password = data['password'];
            },
          )
        },
        onWebViewCreated: (controller) {
          this.controller = controller;
          CookieManager().clearCookies();
          controller.loadUrl('http://webvpn.cust.edu.cn/');
        },
        onPageStarted: (url) {
          setState(() => isBusy = true);
        },
        onPageFinished: (url) async {
          controller.evaluateJavascript(rmHeader);
          controller.evaluateJavascript(loginHook);

          final userData = await locator.getAsync<UserDataStore>();
          final username = userData.username.fetch();
          final password = userData.password.fetch();
          if (username != null || password != null) {
            controller.evaluateJavascript(setUserLoginInfo(username, password));
          }

          setState(() => isBusy = false);
        },
        navigationDelegate: (request) async {
          print('Redirect: ${request.url}');

          if (request.url.contains('webvpn.cust.edu.cn/portal/#!/service')) {
            Future.delayed(200.ms, _loginSuccessCallback);
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String get rmHeader => '''
    (function() {
      var header = document.querySelector('nav.navbar');
      header.parentNode.removeChild(header);
      document.querySelector('main').classList.add('pt-3')
    })();
  ''';

  String get loginHook => '''
    document.querySelector('input[type=submit]').onclick = function() {
      var username = document.querySelector('input[id=username]').value;
      var password = document.querySelector('input[id=password]').value;
      $channel.postMessage(JSON.stringify({
        username: username,
        password: password,
        cookie: document.cookie,
      }));
    }
  ''';

  String setUserLoginInfo(String username, String password) => '''
    (function() {
      document.querySelector('input[id=username]').value = '$username';
      document.querySelector('input[id=password]').value = '$password';
      document.querySelector('input[type=submit]').disabled = false;
    })();
  ''';

  Future<void> _loginSuccessCallback() async {
    Navigator.pop(context);

    final userData = await locator.getAsync<UserDataStore>();
    userData.username.put(this.username);
    userData.password.put(this.password);

    final user = locator<UserProvider>();
    user.login();

    final snake = locator<SnakebarProvider>();
    snake.info('登录成功');
  }

  Widget _buildIndicator(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      child: CupertinoActivityIndicator(),
    );
  }
}
