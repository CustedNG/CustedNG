import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

String get rmFooter => '''
    (function() {
      var header = document.querySelector('.copyright');
      if (header) header.parentNode.removeChild(header);
    })();
  ''';

class PluginForPortal extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.path.startsWith('/custp/index');
    // 不知道这个判断干什么用的，所以没改，但是现在test.cust.edu.cn/custp2已经不用了，
    // 内网外网统一用https://portal.cust.edu.cn或https://portal.cust.edu.cn/custp/index,
    // 另外，portal和其他使用cas的服务推荐使用https协议，不然cas传参可能会出问题
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(rmFooter);
  }
}
