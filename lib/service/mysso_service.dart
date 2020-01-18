import 'package:custed2/api/mysso.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/store/user_store.dart';
import 'package:html/parser.dart' show parse;

class MyssoService {
  final _api = locator<MyssoApi>();

  Future<bool> login() async {
    final loginPage = await _api.getLoginPage();
    if (loginPage.contains('登录成功')) {
      print(loginPage);
      return true;
    }

    final userData = await locator.getAsync<UserDataStore>();

    final loginPageParsed = parse(loginPage);
    final execution =
        loginPageParsed.querySelector('input[name=execution]').attributes['value'];

    final resp = await _api.login(MyssoLoginData(
      username: userData.username.fetch(),
      password: userData.password.fetch(),
      execution: execution,
    ));

    print(resp);
    return true;
  }
}
