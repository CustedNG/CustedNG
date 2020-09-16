import 'dart:convert';

import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final jsAddLoginHook = '''
    document.querySelector('input[type=submit]').onclick = function() {
      var username = document.querySelector('input[id=username]').value;
      var password = document.querySelector('input[id=password]').value;
      Login.postMessage(JSON.stringify({
        username: username,
        password: password,
      }));
    }
  ''';

typedef void LoginCallBack(String username, String password);

class PluginForLogin extends Webview2Plugin {
  PluginForLogin([this.onLogin]);

  final LoginCallBack onLogin;

  @override
  bool shouldActivate(Uri uri) {
    return uri.path.startsWith('/cas/login');
  }

  @override
  String get jsChannel => 'Login';

  @override
  void onChannelMessage(String message) {
    if (onLogin != null) {
      final data = json.decode(message);
      onLogin(data['username'], data['password']);
    }
  }

  @override
  void onPageFinished(FlutterWebviewPlugin webview, String url) async {
    webview.evalJavascript(jsAddLoginHook);
  }
}
