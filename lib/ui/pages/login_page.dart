import 'package:custed2/config/theme.dart';
import 'package:custed2/core/webview/plugin_manager.dart';
import 'package:custed2/core/webview/plugin_set.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final pluginManager = PluginManager();
  WebViewController controller;
  PluginSet plugins;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: theme.webviewNavBarColor,
        actionsForegroundColor: theme.navBarActionsColor,
        middle: Text(
          '登录',
          style: TextStyle(color: theme.navBarActionsColor),
        ),
      ),
      child: WebView(
        onWebViewCreated: (controller) {
          this.controller = controller;
          controller.loadUrl('http://webvpn.cust.edu.cn/');
          // controller.loadUrl('http://ip.cn/');
        },
        onPageStarted: (url) {
          plugins?.onPageStarted(url, controller);
        },
        onPageFinished: (url) {
          plugins?.onPageFinished(url, controller);
        },
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: pluginManager.getChannels(),
        navigationDelegate: (request) async {
          print('Redirect: ${request.url}');
          plugins = pluginManager.getPulgins(Uri.parse(request.url));
          plugins.onEvent('loginData').listen((data) {
            print(data);
          });
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
