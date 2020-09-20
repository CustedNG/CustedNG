import 'dart:convert';

import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

typedef void LoginCallBack(String username, String password);

class PluginForLogin extends Webview2Plugin {
  PluginForLogin([this.onLogin]);

  final LoginCallBack onLogin;

  @override
  bool shouldActivate(Uri uri) {
    return uri.path.startsWith('/cas/login');
  }

  @override
  String get jsChannel => '_custedLogin';

  String get jsAddLoginHook => '''
    document.querySelector('input[type=submit]').onclick = function() {
      var username = document.querySelector('input[id=username]').value;
      var password = document.querySelector('input[id=password]').value;
      $jsChannel(JSON.stringify({
        username: username,
        password: password,
      }));
    }
  ''';

  @override
  void onChannelMessage(String message) {
    if (onLogin != null) {
      final data = json.decode(message);
      onLogin(data['username'], data['password']);
    }
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(jsAddLoginHook);
  }
}
