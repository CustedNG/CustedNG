import 'dart:async';
import 'dart:io';

import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';
import 'package:flutter/cupertino.dart';

class PluginFromRemote extends Webview2Plugin {
  PluginFromRemote() {
    _fetchPlugins();
  }

  final _plugins = Completer<List<String>>();

  Future<void> _fetchPlugins() async {
    final custed = locator<CustedService>();
    try {
      final pluginList = await custed.getWebviewPlugins();
      final result = <String>[];
      for (var url in pluginList) {
        final resp = await custed.get(url);
        if (resp.statusCode == HttpStatus.ok) {
          result.add(resp.body);
        }
      }
      _plugins.complete(result);
    } catch (e) {
      _plugins.completeError(e);
      print('failed to fetch webview plugins');
      rethrow;
    }
  }

  bool shouldActivate(Uri uri) {
    return true;
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    final plugins = await _plugins.future.timeout(Duration(seconds: 20));
    for (var plugin in plugins) {
      await webview.evalJavascript(plugin);
    }
  }
}
