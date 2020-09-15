import 'dart:async';

import 'package:custed2/ui/widgets/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Webview2Progress extends StatefulWidget with PreferredSizeWidget {
  @override
  _Webview2ProgressState createState() => _Webview2ProgressState();

  @override
  Size get preferredSize => CupertinoNavigationBar().preferredSize;
}

class _Webview2ProgressState extends State<Webview2Progress> {
  final webview = FlutterWebviewPlugin();

  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<double> _onProgressChanged;

  bool isLoading = false;
  double progress = 0;

  @override
  void initState() {
    _onStateChanged = webview.onStateChanged.listen(onStateChanged);
    _onProgressChanged = webview.onProgressChanged.listen(onProgressChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onStateChanged?.cancel();
    _onProgressChanged?.cancel();
    super.dispose();
  }

  void onStateChanged(WebViewStateChanged state) {
    if (state.type == WebViewState.abortLoad) {
      isLoading = false;
    }

    if (state.type == WebViewState.startLoad) {
      isLoading = true;
    }

    if (state.type == WebViewState.finishLoad) {
      isLoading = false;
    }

    setState(() {});
  }

  void onProgressChanged(double progress) {
    setState(() {
      this.progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isLoading,
      child: ProgressBar((progress * 100).ceil(), 100, bgColor: null),
    );
  }
}
