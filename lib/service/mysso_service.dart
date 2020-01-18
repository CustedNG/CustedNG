import 'package:custed2/api/mysso.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/store/user_store.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class MyssoService {
  final _api = locator<MyssoApi>();

  login() async {
    final userData = await locator.getAsync<UserDataStore>();
    final loginPage = parse(await _api.getLoginPage());
    final execution =
        loginPage.querySelector('input[name=execution]').attributes['value'];

    final resp = await _api.login(MyssoLoginData(
      username: userData.username.fetch(),
      password: userData.password.fetch(),
      execution: execution,
    ));

    print(resp);
  }
}
