import 'package:custed2/core/webview/addon.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Tiku2Addon extends WebviewAddon {
  bool shouldActivate(Uri uri) {
    return uri.host == 'tiku.lacus.site';
  }

  void onPageFinished(InAppWebViewController controller, String url) async {
    await controller.evaluateJavascript(source: '''
      (function() {
        localStorage.setItem('tiku_theme', 'lightBlue');
        var title = document.querySelector('header p');
        if(title) title.innerHTML = '题库';
      })();
    ''');
  }
}
