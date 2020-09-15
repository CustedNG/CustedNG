import 'dart:async';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

abstract class Webview2Plugin {
  bool shouldActivate(Uri uri);

  FutureOr<void> onPageStarted(FlutterWebviewPlugin webview, String url) {}

  FutureOr<void> onPageFinished(FlutterWebviewPlugin webview, String url) {}
}
