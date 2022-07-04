import 'dart:io';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:custed2/service/wrdvpn_based_service.dart';
import 'package:html/parser.dart' as html;

class IecardService extends WrdvpnBasedService {
  static const authServerUrl = 'http://iecard.cust.edu.cn:8080';
  static const preloginUrl = '$authServerUrl/ias/prelogin?sysid=FWDT';

  static const baseUrl = 'http://iecard.cust.edu.cn';
  static const loginUrl = '$baseUrl/cassyno/index';
  static const homeUrl = '$baseUrl/Category/Page?name=service';
  static const phoneChargeUrl = '$baseUrl/PPage/ComePage';
  static const userUrl = '$baseUrl/PPage/User';
  static const phoneHomeUrl = '$baseUrl/Phone/Index';

  final MyssoService _mysso = locator<MyssoService>();

  @override
  Future<CatLoginResult> login() async {
    final ticket = await _mysso.getTicketForIecard();
    final prelogin = await request('GET', '$preloginUrl&ticket=$ticket'.uri);

    final ssoticketid = html
        .parse(prelogin.body)
        .querySelector('#ssoticketid')
        .attributes['value'];

    final response = await request('POST', loginUrl.uri, body: {
      'errorcode': '1',
      'continueurl': '',
      'ssoticketid': ssoticketid
    });

    return CatLoginResult(ok: response.body.contains('Object moved'));
  }

  Future<String> getEcardLoginUrl() async {
    final resp1 = await xRequest(
      'POST',
      '$baseUrl/Page/Page'.uri,
      maxRedirects: 1,
      body: {
        'flowID': '10002',
        'type': '3',
        'apptype': '4',
        'Url': 'http://iecard.cust.edu.cn:8988/web/common/check.html',
        'MenuName': '交网费',
        'EMenuName': '交网费',
        'parm11': '',
        'parm22': '',
        'comeapp': '1',
        'headnames': '',
        'freamenames': '',
        'shownamess': '',
        'merpagess': '',
        'webheadhide': '',
      },
      expireTest: (resp) =>
          resp.body.contains('/Phone/Login') ||
          resp.headers[HttpHeaders.locationHeader].contains('Login'),
    );

    final resp2 = await xRequest(
      'GET',
      '$baseUrl${resp1.headers[HttpHeaders.locationHeader]}'.uri,
      maxRedirects: 0,
    );

    return resp2.headers[HttpHeaders.locationHeader];
  }
}
