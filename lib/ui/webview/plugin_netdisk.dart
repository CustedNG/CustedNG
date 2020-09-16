import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PluginForNetdisk extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.host == 'yun.cust.edu.cn';
  }

  @override
  void onPageFinished(FlutterWebviewPlugin webview, String url) async {
    await Webview2Plugin.injectCss(
      'div[class*=nav-tabs] {  display: none; }',
    );
    await Webview2Plugin.injectCss(
      'a[href*=home] {  display: none; }',
    );
  }
}
