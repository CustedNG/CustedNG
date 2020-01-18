import 'package:custed2/core/webview/plugin_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class WebviewPlugin {
  final targetPath = '/';

  String channel;

  PluginSet _eventDispatcher;

  setDispatcher(PluginSet dispatcher) {
    _eventDispatcher = dispatcher;
  }

  emitEvent(String name, dynamic data) {
    _eventDispatcher?.dispatchEvent(name, data);
  }

  bool shouldActivate(Uri uri) {
    return uri.path.startsWith(targetPath);
  }

  Widget build() {
    return null;
  }

  String jsPostMessage(String message) {
    if (channel == null) {
      return '';
    }
    return '$channel.postMessage($message)';
  }

  void onPageFinished(String url, WebViewController controller) {}

  void onPageStarted(String url, WebViewController controller) {}

  void onMessage(String message) {}
}
