import 'package:custed2/data/providers/snakebar_provider.dart';
import 'package:custed2/data/providers/user_provider.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/ui/webview/plugin_login.dart';
import 'package:custed2/ui/webview/plugin_mysso.dart';
import 'package:custed2/ui/webview/webview2.dart';
import 'package:custed2/ui/webview/webview2_controller.dart';
import 'package:flutter/cupertino.dart';

class WebviewLogin extends StatefulWidget {
  @override
  _WebviewLoginState createState() => _WebviewLoginState();
}

class _WebviewLoginState extends State<WebviewLogin> {
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Webview2(
      onCreated: onCreated,
      onLoadAborted: onLoadAborted,
      invalidUrlRegex: r'\/portal\/#!\/service',
      plugins: [PluginForMysso(), PluginForLogin(onLoginData)],
    );
  }

  void onCreated(Webview2Controller controller) async {
    await controller.clearCookies();
    controller.loadUrl('http://webvpn.cust.edu.cn/');
  }

  void onLoadAborted(Webview2Controller controller, String url) async {
    if (url.contains('webvpn.cust.edu.cn/portal/#!/service')) {
      loginSuccessCallback(controller);
    }
  }

  void onLoginData(String username, String password) {
    this.username = username;
    this.password = password;
  }

  Future<void> loginSuccessCallback(Webview2Controller controller) async {
    await controller.close();
    Navigator.of(context).pop();

    final userData = await locator.getAsync<UserDataStore>();
    userData.username.put(this.username);
    userData.password.put(this.password);

    final user = locator<UserProvider>();
    user.login();

    final snake = locator<SnakebarProvider>();
    snake.info('登录成功');
  }
}
