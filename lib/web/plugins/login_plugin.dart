import 'dart:convert';

import 'package:custed2/core/webview/plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPlugin extends WebPlugin {
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

  @override
  void onPageFinished(String url, WebViewController controller) {
    controller.evaluateJavascript(rmHeader);
    controller.evaluateJavascript(loginHook);
  }

  @override
  void onMessage(String message) {
    final data = json.decode(message);
    emitEvent('loginData', data);
  }
}
