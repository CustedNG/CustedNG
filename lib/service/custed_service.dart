import 'dart:convert';

import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/res/constants.dart';
import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_file.dart';
import 'package:custed2/data/models/custed_response.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/data/models/tiku_update.dart';
import 'package:custed2/res/build_data.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:http/http.dart' show Response;

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.app';
  static const ccUrl = 'https://cust.cc';

  Future<WeatherData> getWeather() async {
    final resp = await get('$baseUrl/app/weather');
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return WeatherData.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<CustedUpdate> getUpdate() async {
    final build = BuildData.build;
    final resp = await get('$baseUrl/app/apk/newest?build=$build');
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return CustedUpdate.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<String> getRemoteConfigJson() async {
    final resp = await get('$backendUrl/jw/randomUrl');
    return resp.body ?? '{"jwglBaseUrl":"https://jwgls3.cust.edu.cn"}';
  }

  Future<List<String>> getWebviewPlugins() async {
    final resp = await get('$ccUrl/webview/plugins.json');
    return List<String>.from(json.decode(resp.body));
  }

  static String getFileUrl(CustedFile file) {
    if (file == null) return null;
    return file.url.startsWith('/') ? '$baseUrl${file.url}' : file.url;
  }

  Future<String> updateCachedSchedule(String body) async {
    final resp = await post(
      '$backendUrl/schedule',
      headers: {'content-type': 'application/json'},
      body: body,
    );
    return '${resp.statusCode} ${resp.body}';
  }

  Future<Response> getCacheSchedule() async {
    return await get('$backendUrl/schedule');
  }

  Future<bool> sendToken(String token, bool isIOS) async {
    String url;
    if (isIOS) {
      url = "$backendUrl/token/ios";
    } else {
      url = "$backendUrl/token/android";
    }
    Map<String, String> queryParams = {
      "token": token,
    };
    final resp = await post(url, body: queryParams);
    if (resp.statusCode == 200) {
      print('send push token success: $token');
      return true;
    }
    print('send token failed: ${resp.body}');
    return false;
  }

  Future<Response> getCachedGrade() async {
    return await get('$backendUrl/grade');
  }

  Future<Response> getCachedExam() async {
    return await get('$backendUrl/exam');
  }

  Future<void> updateCahedExam(String exam) async {
    final resp = await post('$backendUrl/exam',
        headers: {'content-type': 'application/json'}, body: exam);

    if (resp.statusCode == 200) {
      print('send exam successfully');
    } else {
      print('send exam failed: ${resp.body}');
    }
  }

  Future<void> setPushScheduleNotification(bool open) async {
    final on = open ? 'on' : 'off';
    final resp = await get('$backendUrl/schedule/push/$on');
    print('set schedule push notification: ${resp.statusCode} ${resp.body}');
  }

  Future<void> login2Backend(String cookie, String id) async {
    final resp =
        await post('$backendUrl/verify', body: {'cookie': cookie, 'id': id});
    if (resp.statusCode == 200) {
      print('backend verify success.');
    } else {
      print('backend verify: ${resp.body}');
    }
  }

  Future<String> updateCachedScheduleKBPro(String body) async {
    final resp = await post(
      '$backendUrl/scheduleKBPro',
      headers: {'content-type': 'application/json'},
      body: body,
    );
    return '${resp.statusCode} ${resp.body}';
  }

  Future<Response> getCacheScheduleKBPro() async {
    return await get('$backendUrl/scheduleKBPro');
  }

  Future<bool> isServiceAvailable() async {
    final custApp = (await Dio().head(baseUrl)).statusCode == 200;
    final backend = (await Dio().head(backendUrl)).statusCode == 200;
    return custApp && backend;
  }

  Future<TikuUpdate> getTikuUpdate() async {
    final resp = await get('$backendUrl/res/tiku/update.json');
    if (resp.statusCode == 200) {
      return TikuUpdate.fromJson(json.decode(resp.body));
    }
    return null;
  }

  Future<CustedConfig> getConfig() async {
    final resp = await get('$backendUrl/res/config.json');
    if (resp.statusCode == 200) {
      return CustedConfig.fromJson(json.decode(resp.body));
    }
    return null;
  }
}
