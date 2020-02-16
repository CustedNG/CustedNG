import 'dart:convert';
import 'dart:io';

import 'package:alice/alice.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:custed2/core/util/cookie.dart';
import 'package:custed2/core/webview/user_agent.dart';
import 'package:custed2/locator.dart';
import 'package:http/http.dart';

class CatClient {
  static const kDefaultMaxRedirects = 10;
  static const kDefaultTimeout = Duration(seconds: 20);

  final Client _client = Client();
  final PersistCookieJar _cookieJar = locator<PersistCookieJar>();
  final Alice _alice = locator<Alice>();

  Future<Response> rawRequest(
    String method,
    Uri url, {
    dynamic body,
    Map<String, String> headers = const {},
    int maxRedirects = kDefaultMaxRedirects,
    Duration timeout = kDefaultTimeout,
  }) async {
    print('Cat Request: $method $url');
    final request = CatRequest(method, url);
    request.headers.addAll(headers);
    request.setBody(body);
    // Let's handle redirects manually and correctly :)
    request.followRedirects = false;
    loadCookies(request);
    setUserAgent(request);
    final response = await Response.fromStream(
      await _client.send(request).timeout(timeout),
    );
    saveCookies(response);
    _alice.onHttpResponse(response);
    return await followRedirect(response, maxRedirects);
  }

  Future<Response> get(
    String url, {
    Map<String, String> headers = const {},
    int maxRedirects = kDefaultMaxRedirects,
    Duration timeout = kDefaultTimeout,
  }) {
    return rawRequest(
      'GET',
      Uri.parse(url),
      headers: headers,
      maxRedirects: maxRedirects,
      timeout: timeout,
    );
  }

  Future<Response> post(
    String url, {
    dynamic body,
    Map<String, String> headers = const {},
    int maxRedirects = kDefaultMaxRedirects,
  }) {
    return rawRequest(
      'POST',
      Uri.parse(url),
      body: body,
      headers: headers,
      maxRedirects: maxRedirects,
    );
  }

  Future<Response> followRedirect(Response response, int maxRedirects) async {
    if (maxRedirects <= 0 || !response.isRedirect) {
      return response;
    }

    final method = response.request.method.toUpperCase() == 'POST'
        ? 'GET'
        : response.request.method;

    final url = response.headers[HttpHeaders.locationHeader];

    print('Cat Redirect: $url');
    return await rawRequest(
      method,
      Uri.parse(url),
      headers: response.request.headers,
      maxRedirects: maxRedirects - 1,
    );
  }

  void loadCookies(CatRequest request) {
    // if (request.headers.containsKey(HttpHeaders.cookieHeader)) {
    //   return;
    // }

    final cookies = findCookiesAsString(request.url);
    if (cookies.isNotEmpty) {
      request.headers[HttpHeaders.cookieHeader] = cookies;
    }
  }

  void saveCookies(Response response) {
    var cookieString = response.headers[HttpHeaders.setCookieHeader];
    if (cookieString == null) return;

    cookieString = cookieString.replaceAll(', ', '__custed_comma_space__');
    final cookies = cookieString
        .split(',')
        .map((c) => c.replaceAll('__custed_comma_space__', ', '))
        .map((c) => Cookie.fromSetCookieValue(c))
        .toList();

    _cookieJar.saveFromResponse(response.request.url, cookies);
  }

  List<Cookie> findCookies(Uri uri) {
    final cookies = _cookieJar.loadForRequest(uri);
    cookies.removeWhere((cookie) {
      return cookie.expires != null && cookie.expires.isBefore(DateTime.now());
    });
    return cookies;
  }

  void clearCookieFor(Uri uri) {
    _cookieJar.delete(uri);
  }

  String findCookiesAsString(Uri uri) {
    return formatCookies(findCookies(uri));
  }

  void setUserAgent(Request request) {
    final ua = UserAgent.defaultUA;
    if (request.headers[HttpHeaders.userAgentHeader] == null) {
      request.headers[HttpHeaders.userAgentHeader] = ua;
    }
  }
}

String encodeFormData(Map<String, String> formData) {
  var pairs = <List<String>>[];
  formData.forEach(
    (key, value) => pairs.add([
      Uri.encodeQueryComponent(key),
      Uri.encodeQueryComponent(value),
    ]),
  );
  return pairs.map((pair) => '${pair[0]}=${pair[1]}').join('&');
}

class CatRequest extends Request {
  CatRequest(String method, Uri uri) : super(method, uri);

  void setBody(dynamic body) {
    if (body == null) {
      return;
    }

    if (body is String) {
      this.body = body;
    } else if (body is List) {
      this.bodyBytes = body.cast<int>();
    } else if (body is Map) {
      this.body = encodeBodyFields(body.cast<String, String>());
    } else {
      throw ArgumentError('Invalid request body "$body".');
    }
  }

  String encodeBodyFields(Map<String, String> body) {
    if (!headers.containsKey(HttpHeaders.contentTypeHeader)) {
      headers[HttpHeaders.contentTypeHeader] =
          'application/x-www-form-urlencoded';
    }

    final contentType = headers[HttpHeaders.contentTypeHeader];

    switch (contentType) {
      case 'application/x-www-form-urlencoded':
        return encodeFormData(body);
      case 'application/json':
        return json.encode(body);
      default:
        throw ArgumentError('Unsupported content-type "$contentType".');
    }
  }
}
