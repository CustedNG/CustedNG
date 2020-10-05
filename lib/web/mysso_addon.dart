import 'package:custed2/core/webview/addon.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyssoAddon extends WebviewAddon {
  MyssoAddon();

  @override
  final targetPath = '/cas/login';

  String get rmHeaderFooter => '''
    (function() {
      var header = document.querySelector('nav.navbar');
      if (header) header.parentNode.removeChild(header);
      document.querySelector('main').style = "padding-top: 0;";

      var footer = document.querySelector('footer.footer');
      if (footer) footer.parentNode.removeChild(footer);
    })();
  ''';

  String get rmWxLogin => r'''
    (function() {
      var normalLogin = document.querySelector('form[action="login"]');
      if (normalLogin) normalLogin.parentNode.style = '';
      var wxLogin = document.querySelector('.card-header.text-center');
      if (wxLogin) wxLogin.parentNode.removeChild(wxLogin);
      var wxLogin2 = document.querySelector('#notices');
      if (wxLogin2) wxLogin2.parentNode.removeChild(wxLogin2);
      var wx3 = document.querySelector('[id*="weixin"]')
      if (wx3) wx3.parentNode.removeChild(wx3);
    })();
  ''';

  String setUserLoginInfo(String username, String password) => '''
    (function() {
      document.querySelector('input[id=username]').value = '$username';
      document.querySelector('input[id=password]').value = '$password';
      document.querySelector('input[type=submit]').disabled = false;
    })();
  ''';

  void onPageFinished(InAppWebViewController controller, String url) async {
    controller.evaluateJavascript(source: rmHeaderFooter);
    controller.evaluateJavascript(source: rmWxLogin);

    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();
    final password = userData.password.fetch();

    if (username != null || password != null) {
      controller.evaluateJavascript(
          source: setUserLoginInfo(username, password));
    }
  }
}
