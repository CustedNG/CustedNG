import 'dart:async';

import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/open.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const custcc = 'https://cust.cc/?custed=1';
const custccDark = 'https://cust.cc/?custed=1&dark=1';

class NavTab extends StatefulWidget {
  @override
  _NavTabState createState() => _NavTabState();
}

class _NavTabState extends State<NavTab> with AutomaticKeepAliveClientMixin {
  Widget overlay;
  InAppWebViewController controller;

  @override
  void initState() {
    overlay = Scaffold(
      body: Center(
          child: CircularProgressIndicator()
      ),
    );

    Timer.periodic(500.ms, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      syncDarkMode();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final url = Theme.of(context).brightness == Brightness.dark
        ? custccDark
        : custcc;

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
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  userAgent: UserAgent.defaultUA,
                  useShouldOverrideUrlLoading: true,
                ),
                android: AndroidInAppWebViewOptions(
                  overScrollMode: AndroidOverScrollMode.OVER_SCROLL_NEVER,
                ),
              ),
              initialUrl: url,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onLoadStop: (controller, url) {
                setState(() {
                  overlay = null;
                });
              },
              shouldOverrideUrlLoading: (controller, request) async {
                print('open ${request.url}');

                if (request.url.contains('custed-target=blank')) {
                  openUrl(request.url);
                } else {
                  AppRoute(
                    title: '',
                    page: WebviewBrowser(request.url),
                  ).popup(context);
                }
                return ShouldOverrideUrlLoadingAction.CANCEL;
              },
            ),
            if (overlay != null) overlay,
          ],
        ),
      ),
    );
  }

  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(icon, color: Colors.blue),
            SizedBox(width: 5.0),
            Text(text),
          ],
        ));
  }

  Widget _showMenu(BuildContext context) {
    return PopupMenuButton<String>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.SelectView(Icons.refresh, '刷新此网页', 'A'),
              this.SelectView(Icons.open_in_browser, '浏览器打开', 'B'),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      controller?.evaluateJavascript(source: 'switchToDarkMode()');
    } else {
      controller?.evaluateJavascript(source: 'switchToLightMode()');
    }
  }

  void toggleSideMenu() {
    controller?.evaluateJavascript(source: 'toggleSideMenu()');
  }

  void goHome() {
    controller?.loadUrl(url: custcc);
  }

  @override
  bool get wantKeepAlive => true;
}
