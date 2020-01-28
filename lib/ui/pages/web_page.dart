// import 'package:custed2/config/theme.dart';
// import 'package:flutter/cupertino.dart';

// class WebPage extends StatelessWidget {
//   final title = '';

//   @override
//   Widget build(BuildContext context) {
//     final theme = AppTheme.of(context);

//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         backgroundColor: theme.webviewNavBarColor,
//         actionsForegroundColor: theme.navBarActionsColor,
//         middle: Text(
//           title,
//           style: TextStyle(color: theme.navBarActionsColor),
//         ),
//         trailing: isBusy ? _buildIndicator(context) : null,
//       ),
//       child: WebView(
//         javascriptMode: JavascriptMode.unrestricted,
//         javascriptChannels: pluginManager.getChannels(),
//         onWebViewCreated: (controller) {
//           this.controller = controller;
//           CookieManager().clearCookies();
//           controller.loadUrl('http://webvpn.cust.edu.cn/');
//           // controller.loadUrl('http://ip.cn/');
//         },
//         onPageStarted: (url) {
//           setState(() {
//             isBusy = true;
//           });
//           plugins?.onPageStarted(url, controller);
//         },
//         onPageFinished: (url) {
//           plugins?.onPageFinished(url, controller);
//           setState(() {
//             isBusy = false;
//           });
//         },
//         navigationDelegate: (request) async {
//           print('Redirect: ${request.url}');

//           if (request.url.contains('webvpn.cust.edu.cn/portal/#!/service')) {
//             Future.delayed(Duration(seconds: 1), _loginSuccessCallback);
//             return NavigationDecision.prevent;
//           }

//           plugins = pluginManager.getPulgins(Uri.parse(request.url));
//           plugins.onEvent('loginData').listen((data) async {
//             print(data);
//             username = data['username'];
//             password = data['password'];
//           });
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//   }
// }