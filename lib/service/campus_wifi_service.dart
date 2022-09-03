import 'dart:io';

import 'package:custed2/core/service/cat_client.dart';
import 'package:http/http.dart' show Response;
import 'package:wifi_ip/wifi_ip.dart';

class CampusWiFiService extends CatClient {
  Future<bool> login(String user, String pwd) async {
    final ip = await getIP();

    final body = {
      'DDDDD': user,
      'upass': pwd,
      'R1': '0',
      'R2': '0',
      'R3': '0',
      'R6': '0',
      'para': '00',
      '0MKKey': '123456'
    };

    Map<String, dynamic> param = {
      "c": "ACSetting",
      'a': 'Login',
      'protocol': 'http:',
      'hostname': ip,
      'iTermType': 1,
      'wlanuserip': ip,
      'wlanacip': 'null',
      'wlanacname': 'CCLGXYW-D05-ME60-A&mac=00-00-00-00-00-00',
      'ip': ip,
      'enAdvert': 0,
      'queryACIP': 0,
      'jsVersion': '2.4.3',
      'loginMethod': 1
    };

    final uri = Uri(
        scheme: 'http',
        host: '172.16.30.98',
        port: 801,
        path: '/eportal',
        queryParameters: param);

    final resp = await post(uri.toString(),
        body: body,
        headers: {'content-type': 'application/json'},
        maxRedirects: 0);
    if (isSuccess(resp)) {
      print('[WIFI] Login success');
      return true;
    }
    return false;
  }

  bool isSuccess(Response resp) {
    return resp.headers['Set-Cookie'].isNotEmpty ||
        resp.headers['Cookie'].length > 10;
  }

  Future<String> getIP() async {
    if (Platform.isIOS || Platform.isAndroid) {
      var info = await WifiIp.getWifiIp;
      if (info.ip == null || info.ip == '') throw Exception('get ip failed');
      return info.ip;
    }
    throw Exception('unsupport platform');
  }
}
