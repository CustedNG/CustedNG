import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class WebviewAddon {
  final targetPath = '/';

  bool shouldActivate(Uri uri) {
    return uri.path.startsWith(targetPath);
  }

  Widget build(InAppWebViewController controller, String url) {
    return null;
  }

  FutureOr<void> onPageFinished(InAppWebViewController controller, String url) async {}

  void onPageStarted(InAppWebViewController controller, String url) {}

  static String callHandler(String name, String data) {
    return '''
      window.flutter_inappwebview._callHandler('$name', setTimeout(function(){}), JSON.stringify($data))
    ''';
  }

  static Future injectCss(InAppWebViewController controller, String source) {
    source = source.split('\n').join(r'\n');
    return controller.evaluateJavascript(source: '''
      (function () {
        var node = document.createElement('style');
        node.innerHTML = '$source';
        console.log(node);
        document.getElementsByTagName("head")[0].appendChild(node);
      })();
    ''');
  }
}
