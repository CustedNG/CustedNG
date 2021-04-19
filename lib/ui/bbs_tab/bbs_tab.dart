import 'package:custed2/core/open.dart';
import 'package:custed2/core/route.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class BBSTab extends StatefulWidget {
  @override
  _BBSTabState createState() => _BBSTabState();
}

class _BBSTabState extends State<BBSTab> with AutomaticKeepAliveClientMixin {
  InAppWebViewController controller;
  Future _future;
  final bbsUrl = 'https://bbs.cust.app';

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

    return Scaffold(
      appBar: NavBar.material(
        context: context,
        leading: Container(),
        middle: NavbarMiddle(textAbove: '校内论坛', textBelow: 'bbs.cust.app'),
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
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _buildBrowser(bbsUrl);
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
        syncDarkMode();
      },
      shouldOverrideUrlLoading: (controller, request) async {
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

  SelectView(IconData icon, String text, String id) {
    return PopupMenuItem<String>(
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
              SelectView(Icons.refresh, '刷新此网页', 'A'),
              SelectView(Icons.open_in_browser, '浏览器打开', 'B'),
            ],
        onSelected: (String action) {
          switch (action) {
            case 'A':
              controller.reload();
              break;
            case 'B':
              openUrl(bbsUrl);
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

  void goHome() {
    controller?.loadUrl(urlRequest: bbsUrl.uq);
  }

  @override
  bool get wantKeepAlive => true;
}
