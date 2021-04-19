import 'dart:io';

import 'package:custed2/core/service/cat_client.dart';
import 'package:dio/dio.dart';
import 'package:wifi_ip/wifi_ip.dart';

class CampusWiFiService extends CatClient {
  Future<bool> login(String user, String pwd) async {
    final ip = await getIP();

    final loginUrl = 'http://172.16.30.98:801/eportal/';

     FormData data = FormData.fromMap({
      'DDDDD': user,
      'upass': pwd,
      'R1': '0',
      'R2': '0',
      'R3': '0',
      'R6': '0',
      'para': '00',
      '0MKKey': '123456'
    });

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
    final resp = await Dio().post(
      loginUrl, 
      data: data, 
      queryParameters: param,
      options: Options(
        followRedirects: false,
        validateStatus: (code) => code < 400
      )
    );
    if (isSuccess(resp)) {
      print('campus wifi login success');
      return true;
    }
    return false;
  }

  bool isSuccess(Response resp) {
    return resp.headers['Set-Cookie'].isNotEmpty
        || resp.requestOptions.headers['Cookie'].toString().length > 10;
  }

  Future<String> getIP() async {
    if (Platform.isIOS || Platform.isAndroid) {
      var info = await WifiIp.getWifiIp;;
      if (info.ip == null || info.ip == '') throw Exception('get ip failed');
      return info.ip;
    }
    throw Exception('unsupport platform');
  }
}