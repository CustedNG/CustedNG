import 'dart:convert';

import 'package:custed2/core/webview/plugin.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/user_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPlugin extends WebviewPlugin {
  @override
  final targetPath = '/cas/login';

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

  @override
  void onPageFinished(String url, WebViewController controller) async {
    controller.evaluateJavascript(rmHeader);
    controller.evaluateJavascript(loginHook);

    final userData = await locator.getAsync<UserDataService>();
    final username = userData.username.fetch();
    final password = userData.password.fetch();

    if (username != null || password != null) {
      controller.evaluateJavascript(setUserLoginInfo(username, password));
    }
  }

  @override
  void onMessage(String message) async {
    final data = json.decode(message);
    emitEvent('loginData', data);
    locator<SnakebarProvider>().info('登录成功');
    await Future.delayed(Duration(milliseconds: 5000));
    locator<SnakebarProvider>().clear();

  }
}
