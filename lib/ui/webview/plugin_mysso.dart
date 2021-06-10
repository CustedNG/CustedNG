import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:custed2/ui/webview/webview2_plugin.dart';

import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';

String get rmHeaderFooter => '''
    (function() {
      var header = document.querySelector('nav.navbar');
      if (header) header.parentNode.removeChild(header);
      document.querySelector('main').style = "padding-top: 0; margin-top: 0 !important;";

      var footer = document.querySelector('footer.footer');
      if (footer) footer.parentNode.removeChild(footer);
    })();
  ''';

String get rmWxLogin => r'''
    (function() {
      function action() {
        var normalLogin = document.querySelector('form[action="login"]');
        if (normalLogin) normalLogin.parentNode.style = '';
        if (normalLogin) normalLogin.parentNode.parentNode.style = '';

        var wxLogin = document.querySelector('.card-header.text-center');
        if (wxLogin) wxLogin.parentNode.removeChild(wxLogin);
  
        var wxLogin2 = document.querySelector('#notices');
        if (wxLogin2) wxLogin2.parentNode.removeChild(wxLogin2);

        var wx3 = document.querySelector('[id*="weixin"]')
        if (wx3) wx3.parentNode.removeChild(wx3);

        document.querySelector('#loginform .card').style.paddingTop = '0px'
        document.querySelector('#cardUp').style.paddingTop = '0px'
        document.querySelector('#cardWx').style.paddingTop = '0px'
      }

      var wait = setInterval(function() {
        if (!document.querySelector('#loginform')) {
          return;
        } else {
          clearInterval(wait);
          action();
        }
      }, 200);
    })();
  ''';

String setUserLoginInfo(String username, String password) => '''
    (function() {
      document.querySelector('input[id=username]').value = '$username';
      document.querySelector('input[id=password]').value = '$password';
      document.querySelector('input[type=submit]').disabled = false;
    })();
  ''';

class PluginForMysso extends Webview2Plugin {
  @override
  bool shouldActivate(Uri uri) {
    return uri.path.startsWith('/cas/login');
  }

  @override
  void onPageFinished(Webview2Controller webview, String url) async {
    webview.evalJavascript(rmHeaderFooter);
    webview.evalJavascript(rmWxLogin);

    final userData = await locator.getAsync<UserDataStore>();
    final username = userData.username.fetch();
    final password = userData.password.fetch();

    if (username != null || password != null) {
      webview.evalJavascript(setUserLoginInfo(username, password));
    }
  }
}
