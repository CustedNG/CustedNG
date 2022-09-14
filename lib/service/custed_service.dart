import 'dart:convert';

import 'package:custed2/core/extension/stringx.dart';
import 'package:custed2/data/models/backend_resp.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/jw_kbpro.dart';
import 'package:custed2/res/constants.dart';
import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/data/models/tiku_update.dart';
import 'package:http/http.dart' show Client;

class CustedService extends CatClient {
  static const ccUrl = 'https://cust.cc';

  Future<WeatherData> getWeather() async {
    final resp = await get('$backendUrl/weather');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Get weather: ${custedResp.message}');
    if (custedResp.failed) return null;
    return WeatherData.fromJson(custedResp.data);
  }

  Future<List<String>> getWebviewPlugins() async {
    final resp = await get('$ccUrl/webview/plugins.json');
    return List<String>.from(json.decode(resp.body));
  }

  Future<bool> updateSchedule(String body) async {
    final resp = await post(
      '$backendUrl/schedule',
      headers: {'content-type': 'application/json'},
      body: body,
    );
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Update schedule: ${custedResp.message}');
    return !custedResp.failed;
  }

  Future<JwSchedule> getSchedule() async {
    final resp = await get('$backendUrl/schedule');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Get schedule: ${custedResp.message}');
    if (custedResp.failed) return null;
    return JwSchedule.fromJson(custedResp.data);
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
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Update token: ${custedResp.message}');
    return !custedResp.failed;
  }

  Future<JwGradeData> getGrade() async {
    final resp = await get('$backendUrl/grade');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Get schedule: ${custedResp.message}');
    if (custedResp.failed) return null;
    return JwGradeData.fromJson(custedResp.data);
  }

  Future<JwExam> getExam() async {
    final resp = await get('$backendUrl/exam');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Get exam: ${custedResp.message}');
    if (custedResp.failed) return null;
    return JwExam.fromJson(custedResp.data);
  }

  Future<bool> updateExam(String exam) async {
    final resp = await post('$backendUrl/exam',
        headers: {'content-type': 'application/json'}, body: exam);
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Update exam: ${custedResp.message}');
    return !custedResp.failed;
  }

  Future<bool> setPushScheduleNotification(bool open) async {
    final on = open ? 'on' : 'off';
    final resp = await get('$backendUrl/schedule/push/$on');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Set push schedule to [$on]: ${custedResp.message}');
    return !custedResp.failed;
  }

  Future<bool> login2Backend(String cookie, String id, String url) async {
    final resp = await post('$backendUrl/verify',
        body: {'cookie': cookie, 'id': id, 'url': url});
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Login to backend: ${custedResp.message}');
    return !custedResp.failed;
  }

  Future<bool> updateKBPro(String body) async {
    final resp = await post(
      '$backendUrl/scheduleKBPro',
      headers: {'content-type': 'application/json'},
      body: body,
    );
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Update kbpro: ${custedResp.message}');
    return !custedResp.failed;
  }

  Future<List<JwKbpro>> getCacheScheduleKBPro() async {
    final resp = await get('$backendUrl/scheduleKBPro');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    print('[SERVICE] Get kbpro: ${custedResp.message}');
    if (custedResp.failed) return null;
    return (custedResp.data as List).map((e) => JwKbpro.fromJson(e)).toList();
  }

  Future<bool> isServiceAvailable() async {
    return (await Client().head(backendUrl.uri)).statusCode == 200;
  }

  Future<TikuUpdate> getTikuUpdate() async {
    final resp = await get('$backendUrl/res/tiku/update.json');
    if (resp.statusCode == 200) {
      return TikuUpdate.fromJson(json.decode(resp.body));
    }
    return null;
  }

  Future<CustedConfig> getConfig() async {
    final resp = await get('$backendUrl/config');
    if (resp.statusCode == 200) {
      final custedResp = BackendResp.fromJson(json.decode(resp.body));
      print('[SERVICE] Get config: ${custedResp.message}');
      if (custedResp.failed) return null;
      return CustedConfig.fromJson(custedResp.data);
    }
    return null;
  }
}
