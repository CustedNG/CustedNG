import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/service/webvpn_service.dart';
import 'package:http/http.dart';

abstract class WebvpnBasedService extends CatService {
  final WebvpnService _webvpn = WebvpnService();

  Future<Response> request(
    String method,
    dynamic url, {
    Map<String, String> headers = const {},
    dynamic body,
    int maxRedirects = CatClient.kDefaultMaxRedirects,
  }) {
    return _webvpn.xRequest(method, url,
        headers: headers, body: body, maxRedirects: maxRedirects);
  }
}
