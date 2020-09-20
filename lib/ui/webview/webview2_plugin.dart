import 'dart:async';

import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

abstract class Webview2Plugin {
  bool shouldActivate(Uri uri);

  String get jsChannel => null;

  void onChannelMessage(String message) {}

  FutureOr<void> onPageStarted(Webview2Controller webview, String url) {}

  FutureOr<void> onPageFinished(Webview2Controller webview, String url) {}
}
