import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String get rmFooter => '''
    (function() {
      var header = document.querySelector('.copyright');
      if (header) header.parentNode.removeChild(header);
    })();
  ''';

class PluginForPortal extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.path.startsWith('/custp2/index');
  }

  @override
  void onPageFinished(FlutterWebviewPlugin webview, String url) async {
    webview.evalJavascript(rmFooter);
  }
}
