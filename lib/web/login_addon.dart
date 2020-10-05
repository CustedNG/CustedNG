import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

typedef void LoginCallBack(String username, String password);

class LoginAddon extends WebviewAddon {
  LoginAddon([this.onLogin]);

  final LoginCallBack onLogin;

  @override
  final targetPath = '/cas/login';

  // final jsRmHeader = '''
  //   ;(function() {
  //     var header = document.querySelector('nav.navbar');
  //     header.parentNode.removeChild(header);
  //     document.querySelector('main').classList.add('pt-3')
  //   })();
  // ''';

  final jsAddLoginHook = '''
    document.querySelector('input[type=submit]').onclick = function() {
      var username = document.querySelector('input[id=username]').value;
      var password = document.querySelector('input[id=password]').value;
      window.flutter_inappwebview._callHandler('onLoginData', setTimeout(function(){}), JSON.stringify([{
        username: username,
        password: password,
      }]))
    }
  ''';

  String jsSetUserLoginInfo(String username, String password) => '''
    ;(function() {
      document.querySelector('input[id=username]').value = '$username';
      document.querySelector('input[id=password]').value = '$password';
      document.querySelector('input[type=submit]').disabled = false;
    })();
  ''';

  void onPageFinished(InAppWebViewController controller, String url) async {
    controller.addJavaScriptHandler(
      handlerName: 'onLoginData',
      callback: onLoginData,
    );

    // await controller.evaluateJavascript(source: '''
    //   $jsRmHeader
    //   $jsAddLoginHook
    // ''');

    await controller.evaluateJavascript(source: jsAddLoginHook);

    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();
    final password = userData.password.fetch();

    if (username != null || password != null) {
      controller.evaluateJavascript(
          source: jsSetUserLoginInfo(username, password));
    }
  }

  void onLoginData(List args) {
    if (onLogin != null) {
      onLogin(args.first['username'], args.first['password']);
    }
  }
}
