import 'dart:async';
import 'dart:io';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/data/providers/download_provider.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview2_bottom.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_header.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' hide Cookie;

class Webview2ControllerGeneral extends Webview2Controller {
  Webview2ControllerGeneral(this.controller);

  final InAppWebViewController controller;

  @override
  Future<String> evalJavascript(String source) async {
    final result = await controller.evaluateJavascript(source: source);
    return result.toString();
  }

  @override
  Future<void> clearCookies() {
    return CookieManager.instance().deleteAllCookies();
  }

  @override
  Future<List<Cookie>> getCookies(String url) async {
    final uri = Uri.parse(url);
    final cookies = await CookieManager.instance().getCookies(url: uri);

    final result = <Cookie>[];
    for (var cookie in cookies) {
      final dartCookie = Cookie(cookie.name, cookie.value);
      dartCookie.domain = cookie.domain;
      dartCookie.httpOnly = cookie.isHttpOnly;
      dartCookie.path = cookie.path;
      result.add(dartCookie);
    }

    return result;
  }

  @override
  Future<void> setCookies(List<Cookie> cookies) async {
    for (var cookie in cookies) {
      final url = '${cookie.domain}${cookie.path}';

      var path = '/';
      if (cookie.path != null && cookie.path.isNotEmpty) {
        path = cookie.path;
      }

      await CookieManager.instance().setCookie(
        url: url.uri,
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain,
        path: path,
        isHttpOnly: cookie.httpOnly,
        isSecure: false,
      );
    }
  }

  @override
  Future<void> loadUrl(String url) {
    return controller.loadUrl(urlRequest: url.uq);
  }

  @override
  Future<void> close() {
    return controller.stopLoading();
  }
}

class Webview2StateGeneral extends Webview2State {
  InAppWebViewController controller;

  final header = Webview2HeaderController();
  final bottom = Webview2BottomController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Webview2Header(
        controller: header,
        onClose: (context) {
          Navigator.of(context).pop();
        },
        onReload: (context) {
          controller?.reload();
        },
      ),
      bottomNavigationBar: widget.showBottom
          ? Webview2Bottom(
              controller: bottom,
              url: () => controller?.getUrl(),
              onGoForward: () => controller?.goForward(),
              onGoBack: () => controller?.goBack(),
            )
          : SizedBox(height: 0),
      body: InAppWebView(
        initialUrlRequest: widget.url.uq,
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            userAgent: UserAgent.defaultUA,
            useShouldOverrideUrlLoading: true,
            useOnDownloadStart: true,
          ),
        ),
        onWebViewCreated: (controller) {
          this.controller = controller;
          widget.onCreated?.call(controllerAdaptor);
        },
        onLoadStart: (controller, url) async {
          header.startLoad();
          header.setUrl(url.toString());

          // pluginActivate(url);

          pluginOnLoadStart(controllerAdaptor, url.toString());

          widget.onLoadStart?.call(controllerAdaptor, url.toString());

          bottom.setCanGoBack(await controller.canGoBack());
          bottom.setCanGoForward(await controller.canGoForward());
        },
        onLoadStop: (controller, url) async {
          pluginActivate(url.toString());

          await addJsChannels(controller);

          pluginOnLoadStop(controllerAdaptor, url.toString());

          widget.onLoadStop?.call(controllerAdaptor, url.toString());

          header.stopLoad();
          header.setUrl(url.toString());

          bottom.setCanGoBack(await controller.canGoBack());
          bottom.setCanGoForward(await controller.canGoForward());
        },
        onTitleChanged: (controller, title) {
          header.setTitle(title);
        },
        onProgressChanged: (controller, progress) {
          header.setProgress(progress / 100);
        },
        shouldOverrideUrlLoading: (controller, request) async {
          if (widget.invalidUrlRegex == null) {
            return NavigationActionPolicy.ALLOW;
          }

          final invalidUrlRegex = RegExp(widget.invalidUrlRegex);

          if (invalidUrlRegex.hasMatch(request.request.url.toString())) {
            widget.onLoadAborted
                ?.call(controllerAdaptor, request.request.url.toString());
            return NavigationActionPolicy.CANCEL;
          } else {
            return NavigationActionPolicy.ALLOW;
          }
        },
        onDownloadStartRequest: (controller, url) {
          locator<DownloadProvider>().enqueue(url.toString());
        },
        onConsoleMessage: (controller, message) {
          print('Console: ${message.message}');
        },
      ),
    );
  }

  Future<void> addJsChannels(InAppWebViewController controller) async {
    for (var plugin in widget.plugins) {
      if (plugin.jsChannel == null) {
        continue;
      }

      await controller.addJavaScriptHandler(
        handlerName: plugin.jsChannel,
        callback: (args) {
          if (args.isEmpty) {
            plugin.onChannelMessage(null);
          } else {
            plugin.onChannelMessage(args.first.toString());
          }
        },
      );

      await controller.evaluateJavascript(source: '''
        window.${plugin.jsChannel} = function(arg) {
          // window.flutter_inappwebview._callHandler('${plugin.jsChannel}', setTimeout(function(){}), JSON.stringify([arg]));
          window.flutter_inappwebview.callHandler('${plugin.jsChannel}', arg);
        };
      ''');
    }
  }

  Webview2ControllerGeneral get controllerAdaptor {
    return Webview2ControllerGeneral(controller);
  }
}
