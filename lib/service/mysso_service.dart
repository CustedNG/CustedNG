import 'package:custed2/api/mysso.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/store/user_store.dart';
import 'package:html/parser.dart' show parse;

class MyssoService {
  final _api = locator<MyssoApi>();

  Future<bool> login() async {
    final loginPage = await _api.getLoginPage();
    if (loginPage.contains('登录成功')) {
      print('Mysso Cookie Login Success');
      return true;
    }

    final userData = await locator.getAsync<UserDataStore>();

    final loginPageParsed = parse(loginPage);
    final execution = loginPageParsed
        .querySelector('input[name=execution]')
        .attributes['value'];

    final resp = await _api.login(MyssoLoginData(
      username: userData.username.fetch(),
      password: userData.password.fetch(),
      execution: execution,
    ));

    if (resp.contains('登录成功')) {
      print('Mysso Manual Login Success');
      return true;
    }

    print('Mysso Manual Login Failed');
    return false;
  }

  Future<String> getTicket(String service) async {
    final loginSuccess = await login();
    if(!loginSuccess) {
      return null;
    }

    final ticket = await _api.getTicket(service);
    return ticket;
  }

  Future<void> auth(String service) {
    return _api.auth(service);
  }
}
