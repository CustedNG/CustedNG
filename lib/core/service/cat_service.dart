import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/core/service/cat_error.dart';
import 'package:custed2/core/service/cat_login_result.dart';
import 'package:http/http.dart';

// A CatService mimics a remote service and is able to
// handle cookie expirations or 5xx responses gracefully
abstract class CatService extends CatClient {
  Pattern get sessionExpirationTest => null;
  Pattern get token => '';

  bool isSessionExpired(Response response) {
    if (sessionExpirationTest == null) {
      return false;
    }
    return sessionExpirationTest.allMatches(response.body).isNotEmpty;
  }

  Future<CatLoginResult> login();

  Future<Response> request(
    String method,
    dynamic url, {
    Map<String, String> headers = const {},
    dynamic body,
    int maxRedirects = CatClient.kDefaultMaxRedirects,
  }) {
    return rawRequest(method, url,
        headers: headers, body: body, maxRedirects: maxRedirects);
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
        headers: headers, maxRedirects: maxRedirects, body: body);

    final expired = isSessionExpired(response) ||
        (expireTest != null && expireTest(response));

    if (expired) {
      print('[CAT] Session expiration detected');
      final loginResult = await login();
      if (!loginResult.ok) {
        throw CatError('login() failed');
      }

      response = await request(method, url,
          headers: headers, body: body, maxRedirects: maxRedirects);
    }

    return response;
  }
}
