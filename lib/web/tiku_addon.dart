import 'package:custed2/core/webview/addon.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TikuAddon extends WebviewAddon {
  bool shouldActivate(Uri uri) {
    return uri.host == 'exam.tusi.site';
  }

  void onPageFinished(InAppWebViewController controller, String url) async {
    await controller.evaluateJavascript(source: '''
      (function() {
        // 返回Custed按钮
        var backHome = document.querySelector('.backHome');
        if(backHome) backHome.parentNode.removeChild(backHome);
      })();
    ''');
  }
}
