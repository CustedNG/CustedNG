import 'dart:async';

import 'package:custed2/ui/webview/webview2_bottom.dart';
import 'package:custed2/ui/webview/webview2_header.dart';

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

abstract class Webview2 extends StatefulWidget {
  String get url;

  void onDestroy(Null value) {}
  void onUrlChanged(String value) {}
  void onStateChanged(WebViewStateChanged value) {}
  void onHttpError(WebViewHttpError value) {}
  void onProgressChanged(double value) {}
  void onScrollYChanged(double value) {}
  void onScrollXChanged(double value) {}

  @override
  _Webview2State createState() => _Webview2State();
}

class _Webview2State extends State<Webview2> {
  final wp = FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;

  @override
  void initState() {
    _onDestroy = wp.onDestroy.listen(widget.onDestroy);
    _onUrlChanged = wp.onUrlChanged.listen(widget.onUrlChanged);
    _onStateChanged = wp.onStateChanged.listen(widget.onStateChanged);
    _onHttpError = wp.onHttpError.listen(widget.onHttpError);
    _onProgressChanged = wp.onProgressChanged.listen(widget.onProgressChanged);
    _onScrollXChanged = wp.onScrollXChanged.listen(widget.onScrollXChanged);
    _onScrollYChanged = wp.onScrollYChanged.listen(widget.onScrollYChanged);
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
        userAgent: 'CustedNG',
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
