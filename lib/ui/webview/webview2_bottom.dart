import 'dart:async';

import 'package:custed2/core/open.dart';
import 'package:custed2/ui/widgets/missing_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share_extend/share_extend.dart';

class Webview2Bottom extends StatefulWidget {
  @override
  _Webview2BottomState createState() => _Webview2BottomState();
}

class _Webview2BottomState extends State<Webview2Bottom> {
  final webview = FlutterWebviewPlugin();

  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<String> _onUrlChanged;

  bool canGoBack = false;
  bool canGoForward = false;

  @override
  void initState() {
    _onStateChanged = webview.onStateChanged.listen(onStateChanged);
    _onUrlChanged = webview.onUrlChanged.listen(onUrlChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onStateChanged?.cancel();
    _onUrlChanged?.cancel();
    super.dispose();
  }

  void onStateChanged(WebViewStateChanged state) {
    syncState();
  }

  void onUrlChanged(String url) {
    syncState();
  }

  void syncState() async {
    canGoBack = await webview.canGoBack();
    canGoForward = await webview.canGoForward();
    setState(() {});
  }

  void goForward() {
    webview.goForward();
  }

  void goBack() {
    webview.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.1,
              color: CupertinoColors.opaqueSeparator.resolveFrom(context),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: canGoBack ? goBack : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: canGoForward ? goForward : null,
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                var url = await webview.evalJavascript('window.location.href');
                ShareExtend.share(url, 'text');
              },
            ),
            IconButton(
              icon: const Icon(MissingIcons.earth, size: 26),
              onPressed: () async {
                var url = await webview.evalJavascript('window.location.href');
                if (url.length >= 2) {
                  url = url.substring(1, url.length - 1);
                  openUrl(url);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
