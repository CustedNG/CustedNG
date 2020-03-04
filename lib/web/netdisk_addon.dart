import 'package:custed2/core/webview/addon.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NetdiskAddon extends WebviewAddon {
  bool shouldActivate(Uri uri) {
    print(uri.host);
    return uri.host == '192-168-223-84.webvpn.cust.edu.cn' ||
        uri.host == 'yun-cust-edu-cn.webvpn.cust.edu.cn';
  }

  void onPageFinished(InAppWebViewController controller, String url) async {
    await WebviewAddon.injectCss(
      controller,
      'div[class*=nav-tabs] {  display: none; }',
    );
  }
}
