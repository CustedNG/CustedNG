import 'package:custed2/core/extension/durationx.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class IecardNetFeeAddon extends WebviewAddon {
  bool shouldActivate(Uri uri) {
    return uri.toString().startsWith(
        'http://iecard-cust-edu-cn-8988-p.webvpn.cust.edu.cn:8118/web/common/check.html');
  }

  void onPageFinished(InAppWebViewController controller, String url) async {
    await controller.evaluateJavascript(source: '''
      (function() {
        var nav = document.querySelector('#nav');
        if(nav) nav.parentNode.removeChild(nav);

        var table = document.querySelector('table');
        if(table) table.style = "margin-left: 0;width: 100%;";
      })();
    ''');

    await controller.injectCSSCode(source: r'''
      #content {
        width: initial;
      }
    ''');

    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();
    if (username != null) {
      await 1000.ms.sleep();
      await controller.evaluateJavascript(source: '''
        (function() {
          var input = document.querySelector('#networkid');
          input.value = '$username';
          input.onchange();
        })();
      ''');
    }
  }
}
