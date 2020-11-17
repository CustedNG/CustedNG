import 'dart:io';

import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/core/service/cat_error.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:http/http.dart' show Response;

class WrdvpnService extends CatService {
  static const baseUrl = 'http://wwwn.cust.edu.cn';

  // final Pattern sessionExpirationTest =
  //     locator<MyssoService>().sessionExpirationTest;

  final _mysso = locator<MyssoService>();

  // bool isSessionExpired(Response response) {
  //   if (sessionExpirationTest == null) {
  //     return false;
  //   }
  //   return sessionExpirationTest.allMatches(response.body).isNotEmpty;
  // }

  Future<CatLoginResult> login() async {
    final tryLogin = await get(
      '$baseUrl/wengine-auth/login',
      maxRedirects: 0,
    );

    final redirect = tryLogin.headers[HttpHeaders.locationHeader];
    if (redirect != null && !redirect.contains('mysso')) {
      return CatLoginResult.ok();
    }

    final ticket = await _mysso.getTicketForWrdvpn();

    final resp = await get(
      '$baseUrl/wengine-auth/login?cas_login=true&ticket=$ticket',
      maxRedirects: 0,
    );

    return CatLoginResult(
      ok: resp.statusCode == 302,
    );
  }

  Future<Response> xRequest(
    String method,
    dynamic url, {
    Map<String, String> headers = const {},
    dynamic body,
    int maxRedirects = CatClient.kDefaultMaxRedirects,
    bool expireTest(Response response),
  }) async {
    var response = await request(method, url,
        headers: headers, maxRedirects: 0, body: body);

    final expired = response.headers[HttpHeaders.locationHeader]
        // ?.contains(RegExp(r'wwwn|mysso'));
        ?.contains(RegExp(r'wwwn'));

    if (expired == true) {
      print('Wrdvpn expiration detected');

      final loginResult = await login();

      if (!loginResult.ok) {
        throw CatError('login() failed');
      }

      await followRedirect(response, 2);

      response = await request(method, url,
          headers: headers, body: body, maxRedirects: maxRedirects);
    } else {
      if (response.isRedirect) {
        response = await followRedirect(response, maxRedirects - 1);
      }
    }

    return response;
  }

  Future<String> getBypassUrl(String originalUrl, int id) async {
    originalUrl = Uri.encodeFull(originalUrl);
    try {
      final url = '$baseUrl/wengine-auth/login?id=$id&path=/&from=$originalUrl';
      final resp = await xRequest('GET', url, maxRedirects: 0);
      return resp.headers[HttpHeaders.locationHeader] ?? originalUrl;
    } catch (e) {
      return originalUrl;
    }
  }
}
