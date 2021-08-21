import 'dart:io';

import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_impl_android.dart';
import 'package:custed2/ui/webview/webview2_impl_general.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Webview2 extends StatefulWidget {
  Webview2({
    this.url = 'about:blank',
    this.invalidUrlRegex,
    this.onCreated,
    this.onDestroy,
    this.onUrlChanged,
    this.onLoadStart,
    this.onLoadStop,
    this.onLoadAborted,
    this.onHttpError,
    this.onProgressChanged,
    this.onScrollYChanged,
    this.onScrollXChanged,
    this.plugins = const [],
    this.showBottom = true,
  });

  final String url;

  final String invalidUrlRegex;

  final void Function(Webview2Controller) onCreated;

  final void Function(Null value) onDestroy;
  final void Function(String value) onUrlChanged;
  final void Function(Webview2Controller, String) onLoadStart;
  final void Function(Webview2Controller, String) onLoadStop;
  final void Function(Webview2Controller, String) onLoadAborted;
  final void Function(WebViewHttpError value) onHttpError;
  final void Function(double value) onProgressChanged;
  final void Function(double value) onScrollYChanged;
  final void Function(double value) onScrollXChanged;

  final List<Webview2Plugin> plugins;

  final bool showBottom;

  @override
  Webview2State createState() =>
      // Webview2StateAndroid();
      Platform.isAndroid ? Webview2StateAndroid() : Webview2StateGeneral();
}

abstract class Webview2State extends State<Webview2> {
  var activePlugins = <Webview2Plugin>[];

  Widget buildLoadingWidget() {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  void pluginActivate(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    activePlugins =
        widget.plugins.where((plugin) => plugin.shouldActivate(uri)).toList();

    print('[Webview2] activePlugins $activePlugins');
  }

  void pluginOnLoadStart(Webview2Controller controller, String url) async {
    for (var plugin in activePlugins) {
      await plugin.onPageStarted(controller, url);
    }
  }

  void pluginOnLoadStop(Webview2Controller controller, String url) async {
    for (var plugin in activePlugins) {
      await plugin.onPageFinished(controller, url);
    }
  }
}
