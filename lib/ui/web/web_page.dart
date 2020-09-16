import 'dart:async';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/util/build_mode.dart';
import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/theme.dart';
import 'package:custed2/ui/web/web_page_action.dart';
import 'package:custed2/ui/web/web_page_addon.dart';
import 'package:custed2/ui/web/web_progress.dart';
import 'package:custed2/ui/widgets/back_icon.dart';
import 'package:custed2/ui/widgets/dark_mode_filter.dart';
import 'package:custed2/ui/widgets/navbar/more_btn.dart';
import 'package:custed2/ui/widgets/navbar/navbar_text.dart';
import 'package:custed2/ui/widgets/placeholder/placeholder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPage extends StatefulWidget {
  WebPage({this.defaultUrl});

  final title = '';
  final canGoBack = true;
  final String defaultUrl;
  final String userAgent = null;
  final List<WebPageAction> actions = [];

  @override
  WebPageState createState() => WebPageState();
}

class WebPageState extends State<WebPage> {
  InAppWebViewController controller;

  final progressController = WebProgressController();
  final addonController = WebPageAddonController();

  final addons = <WebviewAddon>[];
  var activeAddons = <WebviewAddon>[];

  bool isBusy = false;
  Widget replace;
  Widget overlay;

  void onCreated() {}

  void onPageStarted(String url) {}

  void onPageFinished(String url) {}

  void onDownloadStart(String url) {}

  Future<bool> onNavigate(ShouldOverrideUrlLoadingRequest request) {
    return Future.value(true);
  }

  void onUrlChange(String url) {
    print(url);
    final uri = url.toUri();
    activeAddons = addons.where((addon) => addon.shouldActivate(uri)).toList();
    addonBuildWidgets(controller, url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: theme.webviewNavBarColor,
        actionsForegroundColor: theme.navBarActionsColor,
        leading: GestureDetector(
          child: BackIcon(),
          onTap: () => Navigator.pop(context),
        ),
        middle: NavbarText(widget.title),
        trailing:
            isBusy ? _buildIndicator(context) : _buildActionButton(context),
      ),
      child: SafeArea(
        child: _buildWebviewWithAddons(context),
      ),
    );
  }

  Widget _buildWebviewWithAddons(BuildContext context) {
    if (replace != null) return replace;

    Widget result = DarkModeFilter(
      child: _buildWebview(context),
      level: 170,
    );

    result = Stack(
      children: <Widget>[
        result,
        if (widget.canGoBack)
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 50,
              height: 50,
              child: material.FloatingActionButton(
                child: Icon(
                  material.Icons.arrow_back,
                  color: CupertinoColors.white,
                  size: 30,
                ),
                onPressed: () async {
                  // Prevent user from go back to the 'loading...' page.
                  final history = await controller.getCopyBackForwardList();
                  if (history.currentIndex <= 1) return;
                  controller?.goBack();
                },
              ),
            ),
          ),
        if (overlay != null) overlay,
      ],
    );

    result = Column(
      children: [
        Flexible(child: result),
        WebPageAddon(addonController),
      ],
    );

    return result;
  }

  Widget _buildWebview(BuildContext context) {
    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          debuggingEnabled: true,
          useShouldOverrideUrlLoading: true,
          useOnDownloadStart: true,
          userAgent: widget.userAgent ?? UserAgent.defaultUA,
        ),
      ),
      onWebViewCreated: (controller) {
        this.controller = controller;
        this.overlayWith(WebProgressLayer(0, 1));
        onCreated();
      },
      onLoadStart: (controller, url) {
        print('INCAT load: $url');
        setState(() => isBusy = true);
        addonOnLoadStart(controller, url);
        this.overlayWith(WebProgress(progressController));
        onPageStarted(url);
      },
      onLoadStop: (controller, url) async {
        setState(() => isBusy = false);
        await listenInAppUrlChange(controller);
        await addonOnLoadStop(controller, url);
        onPageFinished(url);

        // 防止多次重定向出现抖动
        await Future.delayed(Duration(milliseconds: 100));
        final stillLoading = await controller.isLoading();
        if (stillLoading) return;
        if (url == 'about:blank') return;
        this.overlayWith(null);
      },
      onLoadError: (controller, url, code, message) {
        replaceWith(PlaceholderWidget(text: '加载失败[$code]'));
        print('INCAT loadError: $url, $code, $message');
      },
      shouldOverrideUrlLoading: (controller, request) async {
        print('INCAT redirect: ${request.url}');
        final allow = await onNavigate(request);
        return allow
            ? ShouldOverrideUrlLoadingAction.ALLOW
            : ShouldOverrideUrlLoadingAction.CANCEL;
      },
      onProgressChanged: (controller, percent) {
        print(percent);
        progressController?.update(percent, 100);
      },
      onDownloadStart: (controller, url) {
        print('INCAT download: $url');
        onDownloadStart(url);
      },
      onConsoleMessage: (controller, message) {
        if (BuildMode.isDebug) print('|WEBVIEW|: ' + message.message);
      },
    );
  }

  void addonOnLoadStart(InAppWebViewController controller, String url) {
    onUrlChange(url);
    for (var addon in activeAddons) {
      addon.onPageStarted(controller, url);
    }
  }

  Future<void> addonOnLoadStop(
      InAppWebViewController controller, String url) async {
    for (var addon in activeAddons) {
      try {
        await addon.onPageFinished(controller, url);
      } catch (e) {
        print('Addon onPageFinished failed: $e');
      }
    }
  }

  void addonBuildWidgets(InAppWebViewController controller, String url) {
    final widgets = <Widget>[];
    for (var addon in activeAddons) {
      final widget = addon.build(controller, url);
      if (widget != null) widgets.add(widget);
    }
    addonController.update(widgets);
  }

  Widget _buildIndicator(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(brightness: Brightness.dark),
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (widget.actions == null || widget.actions.isEmpty) {
      return null;
    }

    return NavBarMoreBtn(onTap: () => showActionsMenu(context));
  }

  void showActionsMenu(BuildContext context) {
    if (widget.actions == null || widget.actions.isEmpty) {
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (modalContext) {
        return CupertinoActionSheet(
          actions: <Widget>[
            for (var action in widget.actions)
              CupertinoActionSheetAction(
                child: Text(action.name),
                onPressed: () {
                  Navigator.of(modalContext).pop();
                  action.handler(context);
                },
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(modalContext).pop();
            },
          ),
        );
      },
    );
  }

  Future<void> loadCookieFor(String url, {String urlOverride}) async {
    final cookies = locator<PersistCookieJar>().loadForRequest(url.toUri());
    // final uriOverride = urlOverride?.toUri();

    for (var cookie in cookies) {
      print('WEBPAGE cookie $url : <$cookie>');

      final domain = cookie.domain == null
          ? null
          : cookie.domain.startsWith('.') ? cookie.domain : '.' + cookie.domain;

      await CookieManager.instance().setCookie(
        url: urlOverride ?? url,
        name: cookie.name,
        value: cookie.value,
        domain: domain,
        path: cookie.path ?? '/',
        maxAge: cookie.maxAge,
        // isSecure:
        //     uriOverride == null ? cookie.secure : uriOverride.scheme == 'https',
        isSecure: false,
      );
    }
  }

  void replaceWith(Widget widget) {
    setState(() => replace = widget);
  }

  void overlayWith(Widget widget) {
    setState(() => overlay = widget);
  }

  Future<void> listenInAppUrlChange(InAppWebViewController controller) async {
    const handlerName = 'eventUrlChange';
    await controller.addJavaScriptHandler(
      handlerName: handlerName,
      callback: (data) {
        if (data.isEmpty) return;
        final url = data.first;
        if (url is String) {
          onUrlChange(url);
        }
      },
    );

    controller.evaluateJavascript(source: """
      (function() {
        window.callHandler = function(handlerName, message) {
          if (window.flutter_inappwebview.callHandler) {
            window.flutter_inappwebview.callHandler(handlerName, message);
          } else {
            window.flutter_inappwebview._callHandler(handlerName, setTimeout(function(){}), JSON.stringify([message]));
          }
        }

        var lastHref = window.location.href;
        setInterval(function() {
          var href = window.location.href;
          if (lastHref != href) {
            callHandler('$handlerName', href);
            lastHref = href;
          }
        }, 500);
      })();
    """);
  }
}
