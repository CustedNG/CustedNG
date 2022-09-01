import 'dart:io';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:custed2/ui/widgets/select_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const custcc = 'https://cust.cc/?custed=1';
const custccDark = 'https://cust.cc/?custed=1&dark=1';

class NavTab extends StatefulWidget {
  @override
  _NavTabState createState() => _NavTabState();
}

class _NavTabState extends State<NavTab> with AutomaticKeepAliveClientMixin {
  InAppWebViewController controller;
  Future _future;
  bool shouldOverrideUrlLoading = false;

  @override
  void didChangeDependencies() {
    setState(() => syncDarkMode());
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _future = _buildFuture();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (Platform.isMacOS) return Center(child: Text('macOS不支持'));

    return Scaffold(
      appBar: NavBar.material(
        context: context,
        leading: GestureDetector(
          onTap: toggleSideMenu,
          child: Icon(Icons.toggle_off),
        ),
        middle: NavbarMiddle(textAbove: '资源导航', textBelow: 'cust.cc'),
        trailing: [_showMenu(context)],
      ),
      body: FutureBuilder(
        builder: _buildBuilder,
        future: _future,
      ),
    );
  }

  Future _buildFuture() async {
    return Future.delayed(Duration(milliseconds: 377));
  }

  Widget _buildBuilder(BuildContext context, AsyncSnapshot snapshot) {
    final url = isDark(context) ? custccDark : custcc;

    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _buildBrowser(url);
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
      default:
        return Center(
          child: CircularProgressIndicator(),
        );
    }
  }

  Widget _buildBrowser(String url) {
    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          userAgent: UserAgent.defaultUA,
        ),
        android: AndroidInAppWebViewOptions(
          overScrollMode: AndroidOverScrollMode.OVER_SCROLL_NEVER,
        ),
      ),
      initialUrlRequest: url.uq,
      onWebViewCreated: (controller) {
        this.controller = controller;
      },
      onLoadStop: (controller, url) {
        setState(() {
          shouldOverrideUrlLoading = true;
        });
        syncDarkMode();
      },
      shouldOverrideUrlLoading: (controller, request) async {
        if (!shouldOverrideUrlLoading) return NavigationActionPolicy.ALLOW;

        print('open ${request.request.url}');

        if (request.request.url.toString().contains('custed-target=blank')) {
          openUrl(request.request.url.toString());
        } else {
          AppRoute(
            title: 'webview',
            page: WebviewBrowser(request.request.url.toString()),
          ).go(context);
        }

        return NavigationActionPolicy.CANCEL;
      },
    );
  }

  Widget _showMenu(BuildContext context) {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              SelectView(Icons.refresh, '刷新此网页', 'A', context),
              SelectView(Icons.open_in_browser, '浏览器打开', 'B', context),
            ],
        onSelected: (String action) {
          switch (action) {
            case 'A':
              controller.reload();
              break;
            case 'B':
              openUrl(custcc);
              break;
          }
        });
  }

  void syncDarkMode() {
    if (isDark(context)) {
      controller?.evaluateJavascript(source: 'switchToDarkMode()');
    } else {
      controller?.evaluateJavascript(source: 'switchToLightMode()');
    }
  }

  void toggleSideMenu() {
    controller?.evaluateJavascript(source: 'toggleSideMenu()');
  }

  void goHome() {
    controller?.loadUrl(urlRequest: custcc.uq);
  }

  @override
  bool get wantKeepAlive => true;
}
