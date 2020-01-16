import 'dart:async';

import 'package:custed2/web/plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class _Event {
  _Event({
    this.name,
    this.data,
  });

  String name;
  dynamic data;
}

class PluginSet {
  PluginSet({this.plugins});

  List<WebPlugin> plugins;

  final _events = StreamController<_Event>();

  void onPageFinished(String url, WebViewController controller) {
    for (var plugin in plugins) {
      plugin.onPageFinished(url, controller);
    }
  }

  void onPageStarted(String url, WebViewController controller) {
    for (var plugin in plugins) {
      plugin.onPageStarted(url, controller);
    }
  }

  void dispatchEvent(String name, dynamic data) {
    _events.add(_Event(
      name: name,
      data: data,
    ));
  }

  Stream<dynamic> onEvent(String name) {
    return _events.stream.where((e) => e.name == name).map((e) => e.data);
  }
}
