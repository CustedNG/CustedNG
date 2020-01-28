import 'dart:io';

import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:html/parser.dart' show parse;

class MyssoService extends CatService {
  static const baseUrl = 'http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118';
  static const loginUrl = '$baseUrl/cas/login';

  final Pattern sessionExpirationTest = '用户登录';

  Future<bool> login() async {
    final loginPage = await getFrontPage();
    if (loginPage.contains('登录成功')) {
      print('Mysso Cookie Login Success');
      return true;
    }

    final userData = await locator.getAsync<UserDataStore>();

    final loginPageParsed = parse(loginPage);
    final execution = loginPageParsed
        .querySelector('input[name=execution]')
        .attributes['value'];

    final resp = await post(loginUrl, body: {
      'username': userData.username.fetch(),
      'password': userData.password.fetch(),
      'execution': execution,
      '_eventId': 'submit',
      'geolocation': '',
    });

    if (resp.body.contains('登录成功')) {
      print('Mysso Manual Login Success');
      return true;
    }

    print('Mysso Manual Login Failed');
    return false;
  }

  Future<String> getFrontPage() async {
    final resp = await this.get(loginUrl);
    return resp.body;
  }

  Future<String> getTicket(String service) async {
    final response = await xRequest(
      'GET',
      Uri.parse('$baseUrl/cas/login?service=$service'),
      maxRedirects: 0,
    );

    if (response.isRedirect) {
      final location = response.headers[HttpHeaders.locationHeader];
      return Uri.parse(location).queryParameters['ticket'];
    }

    return null;
  }

  Future<String> getTicketForPortal() =>
      getTicket('http://portal.cust.edu.cn/custp/shiro-cas');

  Future<String> getTicketForWebvpn() =>
      getTicket('https://webvpn.cust.edu.cn/auth/cas_validate?entry_id=1');

  Future<String> getTicketForJw() =>
      getTicket('http://192.168.223.72:8080/welcome');
}
