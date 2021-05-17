import 'dart:convert';

import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_banner.dart';
import 'package:custed2/data/models/custed_file.dart';
import 'package:custed2/data/models/custed_response.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/models/custed_update_testflight.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/res/build_data.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:http/http.dart' show Response;

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.app';
  static const ccUrl = 'https://cust.cc';
  static const backendUrl = 'https://push.lolli.tech';
  static const defaultTimeout = Duration(seconds: 100);

  Future<WeatherData> getWeather() async {
    final resp = await get('$baseUrl/app/weather', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return WeatherData.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<String> getNotify() async {
    final build = BuildData.build;
    final resp =
        await get('$backendUrl/notify?build=$build', timeout: defaultTimeout);
    final body = resp.body;
    if (body == '') return null;
    return body;
  }

  Future<CustedUpdate> getUpdate() async {
    final build = BuildData.build;
    final resp = await get('$baseUrl/app/apk/newest?build=$build',
        timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return CustedUpdate.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<CustedUpdateiOS> getiOSUpdate() async {
    final build = BuildData.build;
    final resp = await get('$backendUrl/ios/update?build=$build',
        timeout: defaultTimeout);
    return CustedUpdateiOS.fromJson(
        json.decode(resp.body) as Map<String, dynamic>);
  }

  Future<CustedBanner> getBanner() async {
    final build = BuildData.build;
    final resp =
        await get('$baseUrl/app/banner?build=$build', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return CustedBanner.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<bool> getShouldShowExam() async {
    final resp =
        await get('$backendUrl/res/haveExam', timeout: defaultTimeout);
    if (resp.body != null) return resp.body == '1' ? true : false;
    return false;
  }

  Future<String> getRemoteConfigJson() async {
    final resp =
        await get('$backendUrl/jw/randomUrl', timeout: defaultTimeout);
    return resp.body;
  }

  Future<List<String>> getWebviewPlugins() async {
    final resp = await get('$ccUrl/webview/plugins.json');
    return List<String>.from(json.decode(resp.body));
  }

  static String getFileUrl(CustedFile file) {
    if (file == null) return null;
    return file.url.startsWith('/') ? '$baseUrl${file.url}' : file.url;
  }

  Future<Map> getChangeLog() async {
    final resp = await get('$backendUrl/res/changeLog.json');
    final log = <String, String>{};
    final logs = json.decode(resp.body);
    logs.forEach((element) {
      log[element['ver']] = element['log'];
    });
    return log;
  }

  Future<String> getSchoolCalendarString() async {
    final resp = await get('$backendUrl/res/schoolCalendar.txt');
    return resp.body;
  }

  Future<String> updateScheduleCache2Backend(String ecardId, String body) async {
    final resp = await post(
      '$backendUrl/schedule/$ecardId',
      body: body,
    );
    return '${resp.statusCode} ${resp.body}';
  }

  Future<Response> getCacheScheduleFromBackend(String ecardId) async {
    return await get('$backendUrl/schedule/$ecardId');
  }

  Future<bool> sendToken(String token, String userName, bool isIOS) async {
    String url;
    if (isIOS) {
      url = "$backendUrl/ios/token";
    } else {
      url = "$backendUrl/android/token";
    }
    Map<String, dynamic> queryParams = {
      "token": token,
      // 一卡通号， eg：2019003373
      "id": userName,
    };
    final resp = await Dio().post(url, queryParameters: queryParams);
    if (resp.statusCode == 200) {
      print('send push token success: $token');
      return true;
    }
    return false;
  }
}
