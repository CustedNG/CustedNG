import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

class PluginForNetdisk extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.host == 'yun.cust.edu.cn';
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    await webview.injectCss(
      'div[class*=nav-tabs] {  display: none; }',
    );
    await webview.injectCss(
      'a[href*=home] {  display: none; }',
    );
  }
}
