import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class WebviewAddon {
  final targetPath = '/';

  bool shouldActivate(Uri uri) {
    return uri.path.startsWith(targetPath);
  }

  Widget build(InAppWebViewController controller, String url) {
    return null;
  }

  void onPageFinished(InAppWebViewController controller, String url) {}

  void onPageStarted(InAppWebViewController controller, String url) {}

  static String callHandler(String name, String data) {
    return '''
      window.flutter_inappwebview._callHandler('$name', setTimeout(function(){}), JSON.stringify($data))
    ''';
  }
}
