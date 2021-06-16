import 'dart:convert';

import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_banner.dart';
import 'package:custed2/data/models/custed_file.dart';
import 'package:custed2/data/models/custed_response.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/models/custed_update_ios.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/data/store/user_data_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:http/http.dart' show Response;

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.app';
  static const ccUrl = 'https://cust.cc';
  static const backendUrl = 'https://v2.custed.lolli.tech';
  static const defaultTimeout = Duration(seconds: 10);

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
    final resp = await get('$backendUrl/res/haveExam', timeout: defaultTimeout);
    if (resp.body != null) return resp.body == '1' ? true : false;
    return false;
  }

  Future<String> getRemoteConfigJson() async {
    final resp = await get('$backendUrl/jw/randomUrl', timeout: defaultTimeout);
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

  Future<bool> showRealCustedUI() async {
    final resp = await get('$backendUrl/showRealUI?build=${BuildData.build}');
    return resp.body == '1';
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

  Future<String> getTesterNameList() async {
    final resp = await get('$backendUrl/res/tester');
    if (resp.statusCode == 200) {
      return resp.body;
    }
    return '名单加载失败';
  }

  Future<bool> setPushScheduleNotification(bool open) async {
    final id = locator<UserDataStore>().username.fetch();
    if (id == null) return false;
    final on = open ? 'on' : 'off';
    final resp = await get('$backendUrl/schedule/push/$id/$on');
    return resp.statusCode == 200;
  }

  Future<bool> sendThemeData(String color) async {
    final id = locator<UserDataStore>().username.fetch();
    final resp = await get('$backendUrl/theme/$id/$color');
    return resp.statusCode == 200;
  }

  Future<void> login2Backend(String cookie, String id) async {
    final resp = await post(
      '$backendUrl/verify',
      body: {
        'cookie': cookie,
        'id': id
      }
    );
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

  Future<bool> useKBPro() async {
    final resp = await get('$backendUrl/res/useKBPro');
    return resp.body == 'true';
  }
}
