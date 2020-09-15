import 'dart:async';

import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/ui/webview/webview2_bottom.dart';
import 'package:custed2/ui/webview/webview2_header.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:loading_animations/loading_animations.dart';

// const kAndroidUserAgent =
//     'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class Webview2 extends StatefulWidget {
  Webview2({
    this.url = 'about:blank',
    this.onCreated,
    this.onDestroy,
    this.onUrlChanged,
    this.onStateChanged,
    this.onHttpError,
    this.onProgressChanged,
    this.onScrollYChanged,
    this.onScrollXChanged,
    this.plugins = const [],
  });

  final String url;

  final void Function() onCreated;

  final void Function(Null value) onDestroy;
  final void Function(String value) onUrlChanged;
  final void Function(WebViewStateChanged value) onStateChanged;
  final void Function(WebViewHttpError value) onHttpError;
  final void Function(double value) onProgressChanged;
  final void Function(double value) onScrollYChanged;
  final void Function(double value) onScrollXChanged;

  final List<Webview2Plugin> plugins;

  @override
  _Webview2State createState() => _Webview2State();
}

StreamSubscription<T> listen<T>(Stream<T> source, void Function(T) handler) {
  if (handler == null) {
    return null;
  }

  return source.listen(handler);
}

class _Webview2State extends State<Webview2> {
  final wp = FlutterWebviewPlugin();

  var activePlugins = <Webview2Plugin>[];

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;

  @override
  void initState() {
    _onDestroy = listen(wp.onDestroy, widget.onDestroy);
    _onUrlChanged = listen(wp.onUrlChanged, widget.onUrlChanged);
    _onStateChanged = listen(wp.onStateChanged, onStateChangedWrapper);
    _onHttpError = listen(wp.onHttpError, widget.onHttpError);
    _onProgressChanged = listen(wp.onProgressChanged, widget.onProgressChanged);
    _onScrollXChanged = listen(wp.onScrollXChanged, widget.onScrollXChanged);
    _onScrollYChanged = listen(wp.onScrollYChanged, widget.onScrollYChanged);

    widget?.onCreated();

    super.initState();
  }

  @override
  void dispose() {
    _onDestroy?.cancel();
    _onUrlChanged?.cancel();
    _onStateChanged?.cancel();
    _onHttpError?.cancel();
    _onProgressChanged?.cancel();
    _onScrollXChanged?.cancel();
    _onScrollYChanged?.cancel();

    wp.dispose();

    super.dispose();
  }

  void onStateChangedWrapper(WebViewStateChanged state) async {
    if (state.type == WebViewState.startLoad) {
      final uri = Uri.tryParse(state.url);
      if (uri != null) {
        activePlugins = widget.plugins
            .where((plugin) => plugin.shouldActivate(uri))
            .toList();

        print('activePlugins $activePlugins');
      }
    }

    if (state.type == WebViewState.abortLoad) {
      activePlugins = <Webview2Plugin>[];
    }

    if (state.type == WebViewState.startLoad) {
      for (var plugin in activePlugins) {
        await plugin.onPageStarted(wp, state.url);
      }
    }

    if (state.type == WebViewState.finishLoad) {
      for (var plugin in activePlugins) {
        await plugin.onPageFinished(wp, state.url);
      }
    }

    widget?.onStateChanged?.call(state);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await wp.close();
        return true;
      },
      child: WebviewScaffold(
        url: widget.url,
        javascriptChannels: jsChannels,
        mediaPlaybackRequiresUserGesture: false,
        userAgent: UserAgent.defaultUA,
        ignoreSSLErrors: true,
        appBar: Webview2Header(),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
          child: Center(
            child: LoadingRotating.square(
              borderColor: CupertinoColors.activeBlue,
              size: 30.0,
            ),
          ),
        ),
        // invalidUrlRegex: '^(https).+(portal)',
        bottomNavigationBar: Webview2Bottom(),
      ),
    );
  }
}
