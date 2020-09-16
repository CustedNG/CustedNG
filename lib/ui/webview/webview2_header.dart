import 'dart:async';

import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/webview/webview2_progress.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Webview2Header extends StatefulWidget with PreferredSizeWidget {
  @override
  _Webview2HeaderState createState() => _Webview2HeaderState();

  @override
  Size get preferredSize => CupertinoNavigationBar().preferredSize;
}

class _Webview2HeaderState extends State<Webview2Header> {
  final webview = FlutterWebviewPlugin();

  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<double> _onProgressChanged;

  String host = '...';
  String title = '加载中';
  bool isLoading = false;
  double progress = 0;

  @override
  void initState() {
    _onStateChanged = webview.onStateChanged.listen(onStateChanged);
    _onUrlChanged = webview.onUrlChanged.listen(onUrlChanged);
    _onProgressChanged = webview.onProgressChanged.listen(onProgressChanged);
    super.initState();
  }

  @override
  void dispose() {
    _onStateChanged?.cancel();
    _onUrlChanged?.cancel();
    _onProgressChanged?.cancel();
    super.dispose();
  }

  void onStateChanged(WebViewStateChanged state) async {
    print('onStateChanged ${state.type}');

    if (state.type == WebViewState.abortLoad) {
      isLoading = false;
    }

    if (state.type == WebViewState.startLoad) {
      isLoading = true;
      await syncHost(state.url);
    }

    if (state.type == WebViewState.finishLoad) {
      isLoading = false;
      await syncTitle();
    }

    setState(() {});
  }

  void onUrlChanged(String url) async {
    await syncHost(url);
    await syncTitle();
    setState(() {});
  }

  void onProgressChanged(double progress) {
    setState(() {
      this.progress = progress;
    });
  }

  Future<void> syncHost(String url) async {
    host = Uri?.tryParse(url)?.host ?? url;
    print('host $host');
  }

  Future<void> syncTitle() async {
    title = await getTitle();
    print('title $title');
  }

  Future<String> getTitle() async {
    var title = await webview.evalJavascript('document.title');

    if (title.startsWith('"')) {
      title = title.substring(1);
    }

    if (title.endsWith('"')) {
      title = title.substring(0, title.length - 1);
    }

    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: buildNavigationBar(context)),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 3,
            child: Webview2Progress(),
          ),
        ),
      ],
    );
  }

  Widget buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      leading: Container(
        alignment: Alignment.centerLeft,
        width: 70,
        child: CupertinoButton(
          minSize: 0,
          padding: EdgeInsets.zero,
          child: Text('关闭'),
          onPressed: () async {
            await webview.stopLoading();
            await webview.close();
            webview.dispose();
            Navigator.of(context).pop();
          },
        ),
      ),
      middle: NavbarMiddle(
        textAbove: title ?? '',
        textBelow: host ?? '',
        colorOverride: AppTheme.of(context).textColor,
      ),
      trailing: NavBarMoreBtn(
        icon: CupertinoIcons.refresh,
        onTap: () async {
          webview.reload();
        },
      ),
    );
  }
}
