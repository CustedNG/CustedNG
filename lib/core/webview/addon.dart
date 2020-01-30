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
}
