import 'dart:convert';

import 'package:custed2/core/webview/plugin.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/cookie_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CookiePlugin extends WebviewPlugin {
  @override
  final targetPath = '/';

  String get postCookies => '''
    $channel.postMessage(JSON.stringify({
      location: window.location.href,
      cookie: document.cookie,
    }));
  ''';

  @override
  void onPageFinished(String url, WebViewController controller) {
    controller.evaluateJavascript(postCookies);
  }

  @override
  void onMessage(String message) {
    final data = json.decode(message);
    final cookieService = locator<CookieService>();

  }
}
