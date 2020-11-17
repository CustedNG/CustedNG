import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/utils.dart';
import 'package:custed2/ui/web/web_page.dart';
import 'package:custed2/web/login_addon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LoginWebPage extends WebPage {
  @override
  final title = '登录';

  @override
  final canGoBack = false;

  @override
  _LoginWebPageState createState() => _LoginWebPageState();
}

class _LoginWebPageState extends WebPageState {
  _LoginWebPageState() {
    this.addons.add(LoginAddon(onLoginData));
  }

  String username;
  String password;

  @override
  void onCreated() async {
    await CookieManager.instance().deleteAllCookies();
    await controller.loadUrl(url: 'http://webvpn.cust.edu.cn/');
  }

  // unfortunately this is not working in release mode.
  // See: https://github.com/pichillilorenzo/flutter_inappwebview/issues/237
  @override
  Future<bool> onNavigate(ShouldOverrideUrlLoadingRequest request) async {
    if (request.url.contains('webvpn.cust.edu.cn/portal/#!/service')) {
      loginSuccessCallback();
      return false;
    }
    return true;
  }

  void onLoginData(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Future<void> loginSuccessCallback() async {
    Navigator.pop(context);

    final userData = await locator.getAsync<UserDataStore>();
    userData.username.put(this.username);
    userData.password.put(this.password);

    final user = locator<UserProvider>();
    user.login();

    showSnackBar(context, '登录成功');
  }
}
