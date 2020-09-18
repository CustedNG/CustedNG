import 'dart:async';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

abstract class Webview2Plugin {
  bool shouldActivate(Uri uri);

  String get jsChannel => null;

  void onChannelMessage(String message) {}

  FutureOr<void> onPageStarted(FlutterWebviewPlugin webview, String url) {}

  FutureOr<void> onPageFinished(FlutterWebviewPlugin webview, String url) {}

  static Future injectCss(String source) {
    source = source.split('\n').join(r'\n');
    return FlutterWebviewPlugin().evalJavascript('''
      (function () {
        var node = document.createElement('style');
        node.innerHTML = '$source';
        console.log(node);
        document.getElementsByTagName("head")[0].appendChild(node);
      })();
    ''');
  }
}
