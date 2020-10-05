import 'dart:async';

import 'package:custed2/ui/webview/webview2_controller.dart';

abstract class Webview2Plugin {
  bool shouldActivate(Uri uri);

  String get jsChannel => null;

  void onChannelMessage(String message) {}

  FutureOr<void> onPageStarted(Webview2Controller webview, String url) {}

  FutureOr<void> onPageFinished(Webview2Controller webview, String url) {}
}
