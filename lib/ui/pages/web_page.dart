import 'dart:async';
import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/config/theme.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/widgets/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPage extends StatefulWidget {
  WebPage({this.canGoBack = true});

  final title = '';
  final bool canGoBack;

  @override
  WebPageState createState() => WebPageState();
}

class WebPageState extends State<WebPage> {
  InAppWebViewController controller;
  List<WebviewAddon> activeAddons = [];

  List<Widget> addonWidgets = [];
  bool isBusy = false;

  final addons = <WebviewAddon>[];
  void onCreated() {}
  void onPageStarted(String url) {}
  void onPageFinished(String url) {}

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: theme.webviewNavBarColor,
        actionsForegroundColor: theme.navBarActionsColor,
        middle: Text(
          widget.title,
          style: TextStyle(color: theme.navBarActionsColor),
        ),
        trailing: isBusy ? _buildIndicator(context) : null,
      ),
      child: SafeArea(
        child: _buildWebviewWithAddons(context),
      ),
    );
  }

  Widget _buildWebviewWithAddons(BuildContext context) {
    final theme = AppTheme.of(context);

    Widget result = _buildWebview(context);

    if (widget.canGoBack) {
      result = Stack(
        children: <Widget>[
          result,
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 50,
              height: 50,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                color: theme.webviewNavBarColor,
                child: Icon(
                  material.Icons.arrow_back,
                  color: CupertinoColors.white,
                  size: 30,
                ),
                onPressed: () => controller?.goBack(),
              ),
            ),
          )
        ],
      );
    }

    if (addonWidgets.isNotEmpty) {
      result = BottomSheet(
        child: result,
        sheet: Container(
          padding: EdgeInsets.all(5),
          child: Column(children: addonWidgets),
        ),
      );
    }

    return result;
  }

  Widget _buildWebview(BuildContext context) {
    return InAppWebView(
      initialUrl: generateInitPage(),
      initialOptions: InAppWebViewWidgetOptions(
        crossPlatform: InAppWebViewOptions(
          debuggingEnabled: true,
          useShouldOverrideUrlLoading: true,
        ),
      ),
      onWebViewCreated: (controller) {
        this.controller = controller;
        onCreated();
      },
      onLoadStart: (controller, url) {
        print('INCAT load: $url');
        setState(() => isBusy = true);
        addonOnLoadStart(controller, url);
        onPageStarted(url);
      },
      onLoadStop: (controller, url) {
        setState(() => isBusy = false);
        addonOnLoadStop(controller, url);
        onPageFinished(url);
      },
      shouldOverrideUrlLoading: (controller, request) async {
        print('INCAT redirect: ${request.url}');
        return ShouldOverrideUrlLoadingAction.ALLOW;
      },
    );
  }

  void addonOnLoadStart(InAppWebViewController controller, String url) {
    final uri = url.toUri();
    activeAddons = addons.where((addon) => addon.shouldActivate(uri)).toList();
    addonBuildWidgets(controller, url);
    for (var addon in activeAddons) addon.onPageStarted(controller, url);
  }

  void addonOnLoadStop(InAppWebViewController controller, String url) {
    for (var addon in activeAddons) addon.onPageFinished(controller, url);
  }

  void addonBuildWidgets(InAppWebViewController controller, String url) {
    final widgets = <Widget>[];
    for (var addon in activeAddons) {
      final widget = addon.build(controller, url);
      if (widget != null) widgets.add(widget);
    }
    // setState(() => addonWidgets = widgets);
  }

  Widget _buildIndicator(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(brightness: Brightness.dark),
      child: CupertinoActivityIndicator(),
    );
  }

  Future<void> loadCookieFor(String url) async {
    final cookies = locator<PersistCookieJar>().loadForRequest(url.toUri());
    for (var cookie in cookies) {
      await CookieManager.instance().setCookie(
        url: url,
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain,
        path: cookie.path,
        maxAge: cookie.maxAge,
        isSecure: cookie.secure,
      );
    }
  }

  static String generateInitPage() {
    final template = '''
      <!DOCTYPE html><html>
      <head>
        <title>Loading</title>
        <script>
          (function() {
            var n = 0;
            var d = ['', '.', '..', '...'];
            setInterval(function() {
              document.querySelector('.loading').innerHTML = 'Loading' + d[n % d.length];
              n++;
            }, 100);
          })();
        </script>
      </head>
      <body>
        <div class="loading">
          Loading...
        </div>
      </body>
      </html>
    ''';
    final contentBase64 = base64.encode(utf8.encode(template));
    return 'data:text/html;base64,$contentBase64';
  }
}
