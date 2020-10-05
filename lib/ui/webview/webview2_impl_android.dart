import 'dart:async';
import 'dart:io';

import 'package:custed2/core/open.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_header.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';
import 'package:custed2/ui/widgets/missing_icons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share_extend/share_extend.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

StreamSubscription<T> listen<T>(Stream<T> source, void Function(T) handler) {
  if (handler == null) {
    return null;
  }

  return source.listen(handler);
}

class Webview2ControllerAndroid extends Webview2Controller {
  @override
  Future<String> evalJavascript(String source) async {
    var result = await FlutterWebviewPlugin().evalJavascript(source);

    if (result.startsWith('"')) {
      result = result.substring(1);
    }

    if (result.endsWith('"')) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }

  @override
  void loadUrl(String url) {
    FlutterWebviewPlugin().reloadUrl(url);
  }

  @override
  Future<void> clearCookies() {
    return WebviewCookieManager().clearCookies();
  }

  @override
  Future<void> setCookies(List<Cookie> cookies) {
    return WebviewCookieManager().setCookies(cookies);
  }

  @override
  Future<void> close() {
    return FlutterWebviewPlugin().close();
  }
}

class Webview2StateAndroid extends Webview2State {
  final wp = FlutterWebviewPlugin();

  final header = Webview2HeaderController();

  bool canBack = false;
  bool canForward = false;

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  StreamSubscription<double> _onProgressChanged;
  StreamSubscription<double> _onScrollYChanged;
  StreamSubscription<double> _onScrollXChanged;

  @override
  void initState() {
    _onDestroy = listen(wp.onDestroy, widget.onDestroy);
    _onUrlChanged = listen(wp.onUrlChanged, onUrlChangedWrapper);
    _onStateChanged = listen(wp.onStateChanged, onStateChangedWrapper);
    _onHttpError = listen(wp.onHttpError, widget.onHttpError);
    _onProgressChanged = listen(wp.onProgressChanged, onProgressChangedWrapper);
    _onScrollXChanged = listen(wp.onScrollXChanged, widget.onScrollXChanged);
    _onScrollYChanged = listen(wp.onScrollYChanged, widget.onScrollYChanged);

    widget?.onCreated(Webview2ControllerAndroid());

    super.initState();
  }

  @override
  void dispose() {
    _onDestroy?.cancel();
    _onUrlChanged?.cancel();
    _onStateChanged?.cancel();
    _onHttpError?.cancel();
    _onProgressChanged?.cancel();
    _onScrollXChanged?.cancel();
    _onScrollYChanged?.cancel();

    wp.dispose();

    super.dispose();
  }

  @override
  void reassemble(){
    wp.dispose();
    super.reassemble();
  }

  void onUrlChangedWrapper(String url) async {
    widget.onUrlChanged?.call(url);

    header.setUrl(url);
    header.setTitle(await getTitle());
  }

  void onProgressChangedWrapper(double progress) async {
    header.setProgress(progress);

    widget.onProgressChanged?.call(progress);
  }

  void onStateChangedWrapper(WebViewStateChanged state) async {
    if (state.type == WebViewState.abortLoad) {
      header.stopLoad();
      activePlugins = <Webview2Plugin>[];
    }

    if (state.type == WebViewState.startLoad) {
      header.startLoad();
      header.setUrl(state.url);

      pluginActivate(state.url);

      pluginOnLoadStart(Webview2ControllerAndroid(), state.url);

      widget.onLoadStart?.call(Webview2ControllerAndroid(), state.url);

      canBack = await wp.canGoBack();
      canForward = await wp.canGoForward();
      setState(() {});
    }

    if (state.type == WebViewState.finishLoad) {
      await setupJsChannels();

      pluginOnLoadStop(Webview2ControllerAndroid(), state.url);

      widget.onLoadStop?.call(Webview2ControllerAndroid(), state.url);

      header.setTitle(await getTitle());
      header.stopLoad();
    }

    if (state.type == WebViewState.shouldStart) {
      print('shouldStart ${state.url}');
      // locator<DownloadProvider>().enqueue(state.url);
      widget.onLoadAborted?.call(Webview2ControllerAndroid(), state.url);
    }
  }

  Future<String> getTitle() {
    return evalJs('document.title');
  }

  Future<String> getUrl() {
    return evalJs('window.location.href');
  }

  Future<String> evalJs(String source) async {
    var result = await wp.evalJavascript(source);

    if (result.startsWith('"')) {
      result = result.substring(1);
    }

    if (result.endsWith('"')) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).iconTheme.color.withOpacity(0.5);

    return WillPopScope(
      onWillPop: () async {
        await wp.stopLoading();
        await wp.close();
        return true;
      },
      child: WebviewScaffold(
        url: widget.url,
        invalidUrlRegex: widget.invalidUrlRegex,
        javascriptChannels: getJsChannels(),
        mediaPlaybackRequiresUserGesture: false,
        userAgent: UserAgent.defaultUA,
        ignoreSSLErrors: true,
        appBar: Webview2Header(
          controller: header,
          onClose: (context) async {
            await wp.stopLoading();
            await wp.close();
            wp.dispose();
            Navigator.of(context).pop();
          },
          onReload: (context) async {
            await wp.reload();
          },
        ),
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: buildLoadingWidget(),
        bottomNavigationBar: BottomAppBar(
          color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.1,
                  color: CupertinoColors.opaqueSeparator.resolveFrom(context),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: canBack
                        ? const Icon(Icons.arrow_back_ios)
                        : Icon(Icons.arrow_back_ios, color: iconColor),
                    onPressed: () async {
                      wp?.goBack();
                    }
                ),
                IconButton(
                  icon: canForward
                      ? const Icon(Icons.arrow_forward_ios)
                      : Icon(Icons.arrow_forward_ios, color: iconColor),
                  onPressed: () async {
                    wp?.goForward();
                  } ,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    // var url = await webview.evalJavascript('window.location.href');
                    final url = await getUrl();
                    ShareExtend.share(url, 'text');
                  },
                ),
                IconButton(
                  icon: const Icon(MissingIcons.earth, size: 26),
                  onPressed: () async {
                    // var url = await webview.evalJavascript('window.location.href');
                    // if (url.length >= 2) {
                    //   url = url.substring(1, url.length - 1);
                    // }
                    final url = await getUrl();
                    openUrl(url);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: prefer_collection_literals
  Set<JavascriptChannel> getJsChannels() {
    final channels = <JavascriptChannel>{};

    for (var plugin in widget.plugins) {
      if (plugin.jsChannel == null) {
        continue;
      }

      final channel = JavascriptChannel(
        name: plugin.jsChannel,
        onMessageReceived: (JavascriptMessage message) {
          plugin.onChannelMessage(message.message);
        },
      );

      channels.add(channel);
    }

    return channels;
  }

  Future<void> setupJsChannels() async {
    for (var plugin in activePlugins) {
      if (plugin.jsChannel == null) {
        continue;
      }

      await wp.evalJavascript('''
        (function() {
          var channel = window.${plugin.jsChannel};
          window.${plugin.jsChannel} = function(arg) {
            channel.postMessage(arg);
          };
        })();
      ''');
    }
  }
}
