import 'package:custed2/core/open.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/ui/nav_tab/nav_tab_toggle.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview_browser.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/ui/widgets/navbar/navbar.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:loading_animations/loading_animations.dart';

const custcc = 'https://cust.cc/?custed=1';

class NavTab extends StatefulWidget {
  @override
  _NavTabState createState() => _NavTabState();
}

class _NavTabState extends State<NavTab> {
  Widget overlay;
  InAppWebViewController controller;

  @override
  void initState() {
    super.initState();
    overlay = Center(
      child: LoadingRotating.square(
        borderColor: CupertinoColors.activeBlue,
        size: 30.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NavBar.cupertino(
        context: context,
        leading: NavTabToggle(onTap: toggleSideMenu),
        middle: NavbarMiddle(textAbove: '资源导航', textBelow: 'cust.cc'),
        trailing: NavBarMoreBtn(onTap: () => openMenu(context)),
      ),
      child: SafeArea(
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
              initialUrl: custcc,
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              onLoadStop: (controller, url) {
                setState(() {
                  overlay = null;
                });
              },
              shouldOverrideUrlLoading: (controller, request) async {
                print('request ${request.url}');
                // Navigator.of(context, rootNavigator: true).push(
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return Webview2();
                //     },
                //   ),
                // );
                showCupertinoModalPopup(context: context, builder: (context) {
                  return WebviewBrowser(request.url);
                });
                return ShouldOverrideUrlLoadingAction.CANCEL;
              },
            ),
            if (overlay != null) overlay,
          ],
        ),
      ),
    );
  }

  void toggleSideMenu() {
    controller?.evaluateJavascript(source: 'toggleSideMenu()');
  }

  void goHome() {
    controller?.loadUrl(url: custcc);
  }

  void openInBrowser() {
    openUrl(custcc);
  }

  void openMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          message: Text('校内资源导航'),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('回到主页'),
              onPressed: () {
                Navigator.of(context).pop();
                goHome();
              },
            ),
            CupertinoActionSheetAction(
              child: Text('在浏览器中打开'),
              onPressed: () {
                Navigator.of(context).pop();
                openInBrowser();
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
