import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

class PluginForNav extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.toString().startsWith('https://cust.cc');
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    int now = DateTime.now().hour;
    bool isNight = now < 8 || now > 19;
    String jsScript = isNight ? 'switchToDarkMode()' : 'switchToLightMode()';
    webview.evalJavascript(jsScript);
  }
}
