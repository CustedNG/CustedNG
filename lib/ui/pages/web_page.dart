import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/config/theme.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/webview/plugin_manager.dart';
import 'package:custed2/core/webview/plugin_set.dart';
import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPage extends StatefulWidget {
  final title = '';

  @override
  WebPageState createState() => WebPageState();
}

class WebPageState extends State<WebPage> {
  final pluginManager = PluginManager();
  InAppWebViewController controller;
  PluginSet plugins;
  bool isBusy = false;

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
      child: InAppWebView(
        initialUrl: generateInitPage(),
        initialOptions: InAppWebViewWidgetOptions(
          crossPlatform: InAppWebViewOptions(
            debuggingEnabled: true,
            useShouldOverrideUrlLoading: true,
          ),
        ),
        // javascriptMode: JavascriptMode.unrestricted,
        // javascriptChannels: pluginManager.getChannels(),
        // initialUrl: generateInitPage(),
        // initialUrl: 'https://cust.xuty.cc',
        onWebViewCreated: (controller) {
          this.controller = controller;
          onCreated();
        },
        onLoadStart: (controller, url) {
          print('INCAT load: $url');
          setState(() => isBusy = true);
          // plugins?.onPageStarted(url, controller);
          onPageStarted(url);
        },
        onLoadStop: (controller, url) {
          // plugins?.onPageFinished(url, controller);
          setState(() => isBusy = false);
          onPageFinished(url);
        },
        shouldOverrideUrlLoading: (controller, request) async {
          print('INCAT redirect: ${request.url}');
          return ShouldOverrideUrlLoadingAction.ALLOW;
        },
        // navigationDelegate: (request) async {
        //   print('Redirect: ${request.url}');
        //   plugins = pluginManager.getPulgins(Uri.parse(request.url));
        //   return NavigationDecision.navigate;
        // },
      ),
    );
  }

  void onCreated() {}
  void onPageStarted(String url) {}
  void onPageFinished(String url) {}

  Widget _buildIndicator(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
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
      </head>
      <body>
        Loading...
      </body>
      </html>
    ''';
    final contentBase64 = base64.encode(utf8.encode(template));
    return 'data:text/html;base64,$contentBase64';
  }
}
