import 'dart:io';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/data/models/mysso_profile.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:html/parser.dart' show parse;

class MyssoService extends CatService {
  static const baseUrl = 'http://mysso-cust-edu-cn-s.webvpn.cust.edu.cn:8118';
  static const loginUrl = '$baseUrl/cas/login';

  static String parseValue(String value) {
    // just handle string case for now.
    // [xxx] -> xxx
    return value.substring(1, value.length - 1);
  }

  final Pattern sessionExpirationTest = RegExp(r'(用户登录|登录后可|微信扫码|账号密码)');

  Future<CatLoginResult<String>> login({bool force = false}) async {
    if (force) clearCookieFor(baseUrl.toUri());

    final loginPage = await getFrontPage();
    if (loginPage.contains('登录成功')) {
      print('Mysso Cookie Login Success');
      return CatLoginResult.ok();
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
      return CatLoginResult.ok();
    }

    final reason =
        parse(resp.body).querySelector('.alert-danger')?.text?.trim() ?? '未知原因';
    print('Mysso Manual Login Failed：$reason');
    return CatLoginResult.failed(reason);
  }

  Future<MyssoProfile> getProfile() async {
    final document = parse((await xRequest('GET', loginUrl.toUri())).body);
    final custId = document.querySelector('strong > span').innerHtml;
    final data = Map.fromIterables(
      document.querySelectorAll('td > kbd > span').map((e) => e.innerHtml),
      document.querySelectorAll('td > code > span').map((e) => e.innerHtml),
    );
    return MyssoProfile(
      custId: custId,
      name: data['CN'],
      surname: data['SN'],
      cookie: data['cookie'],
      memberOf: data['MEMBEROF'],
      pass: data['PASS'],
      college: data['college'],
      grade: int.tryParse((data['grade'])),
      sno: data['sno'],
    );
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

  Future<String> getTicketForIecard() =>
      getTicket('http://iecard.cust.edu.cn:8080/ias/prelogin?sysid=FWDT');

  Future<String> getTicketForNetdisk() =>
      getTicket('http://tx.cust.edu.cn/ucsso/shiro-cas');
}
