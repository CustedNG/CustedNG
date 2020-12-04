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
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(rmFooter);
  }
}
