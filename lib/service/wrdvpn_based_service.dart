import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/core/service/cat_service.dart';
import 'package:custed2/service/wrdvpn_service.dart';
import 'package:http/http.dart';

abstract class WrdvpnBasedService extends CatService {
  final _wrdvpn = WrdvpnService();

  Future<Response> request(
    String method,
    dynamic url, {
    Map<String, String> headers = const {},
    dynamic body,
    int maxRedirects = CatClient.kDefaultMaxRedirects,
  }) {
    return _wrdvpn.xRequest(method, url,
        headers: headers, body: body, maxRedirects: maxRedirects);
  }
}
