import 'dart:convert';

import 'package:custed2/data/models/backend_resp.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/data/models/jw_exam.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/kbpro_schedule.dart';
import 'package:custed2/res/constants.dart';
import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/data/models/tiku_update.dart';
import 'package:dio/dio.dart' show Dio;

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.app';
  static const ccUrl = 'https://cust.cc';

  Future<WeatherData> getWeather() async {
    final resp = await get('$backendUrl/weather');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) return null;
    return WeatherData.fromJson(custedResp.data);
  }

  Future<List<String>> getWebviewPlugins() async {
    final resp = await get('$ccUrl/webview/plugins.json');
    return List<String>.from(json.decode(resp.body));
  }

  Future<bool> updateCachedSchedule(String body) async {
    final resp = await post(
      '$backendUrl/schedule',
      headers: {'content-type': 'application/json'},
      body: body,
    );
    return BackendResp.fromJson(json.decode(resp.body)).failed;
  }

  Future<JwSchedule> getCacheSchedule() async {
    final resp = await get('$backendUrl/schedule');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) return null;
    return JwSchedule.fromJson(custedResp.data);
  }

  Future<void> sendToken(String token, bool isIOS) async {
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
    if (custedResp.failed) {
      return print('send token failed: ${custedResp.message}');
    }
    print('send token success: $token');
  }

  Future<JwGradeData> getCachedGrade() async {
    final resp = await get('$backendUrl/grade');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) return null;
    return JwGradeData.fromJson(custedResp.data);
  }

  Future<JwExam> getCachedExam() async {
    final resp = await get('$backendUrl/exam');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) return null;
    return JwExam.fromJson(custedResp.data);
  }

  Future<void> updateCahedExam(String exam) async {
    final resp = await post('$backendUrl/exam',
        headers: {'content-type': 'application/json'}, body: exam);

    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) {
      return print('update exam failed: ${custedResp.message}');
    }
    print('update exam success');
  }

  Future<void> setPushScheduleNotification(bool open) async {
    final on = open ? 'on' : 'off';
    final resp = await get('$backendUrl/schedule/push/$on');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) {
      return print(
          'set push schedule notification failed: ${custedResp.message}');
    }
    print('set push schedule notification success');
  }

  Future<void> login2Backend(String cookie, String id) async {
    final resp =
        await post('$backendUrl/verify', body: {'cookie': cookie, 'id': id});
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) {
      return print('login to backend failed: ${custedResp.message}');
    }
    print('login to backend success');
  }

  Future<void> updateCachedScheduleKBPro(String body) async {
    final resp = await post(
      '$backendUrl/scheduleKBPro',
      headers: {'content-type': 'application/json'},
      body: body,
    );
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) {
      return print('update kbpro schedule failed: ${custedResp.message}');
    }
    print('update kbpro schedule success');
  }

  Future<List<KBProSchedule>> getCacheScheduleKBPro() async {
    final resp = await get('$backendUrl/scheduleKBPro');
    final custedResp = BackendResp.fromJson(json.decode(resp.body));
    if (custedResp.failed) return null;
    return (custedResp.data as List)
        .map((e) => KBProSchedule.fromJson(e))
        .toList();
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
      return CustedConfig.fromJson(json.decode(utf8.decode(resp.bodyBytes)));
    }
    return null;
  }
}
