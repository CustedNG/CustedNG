import 'dart:convert';

import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_banner.dart';
import 'package:custed2/data/models/custed_file.dart';
import 'package:custed2/data/models/custed_response.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/models/custed_update_testflight.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/res/build_data.dart';

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.app';
  static const ccUrl = 'https://cust.cc';
  static const defaultTimeout = Duration(seconds: 100);

  Future<WeatherData> getWeather() async {
    final resp = await get('$baseUrl/app/weather', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return WeatherData.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<String> getHotfix() async {
    final build = BuildData.build;
    final resp =
        await get('$ccUrl/api/notify?build=$build', timeout: defaultTimeout);
    final body = resp.body;
    if (body == null || body == '') return null;
    return body;
  }

  Future<String> getScript(String name) async {
    final resp = await get('$baseUrl/hub/$name.cl', timeout: defaultTimeout);
    return resp.body;
  }

  Future<CustedUpdate> getUpdate() async {
    final build = BuildData.build;
    final resp = await get('$baseUrl/app/apk/newest?build=$build',
        timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return CustedUpdate.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<CustedUpdateTestflight> getTestflithgUpdate() async {
    final build = BuildData.build;
    final resp = await get('https://cust.cc/api/update/ios?build=$build',
        timeout: defaultTimeout);
    return CustedUpdateTestflight.fromJson(
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
        await get('https://cust.cc/api/haveExam', timeout: defaultTimeout);
    if (resp.body != null) return resp.body == '1' ? true : false;
    return false;
  }

  Future<String> getRemoteConfigJson() async {
    final resp =
        await get('https://cust.cc/api/config', timeout: defaultTimeout);
    return resp.body;
  }

  static String getFileUrl(CustedFile file) {
    if (file == null) return null;
    return file.url.startsWith('/') ? '$baseUrl${file.url}' : file.url;
  }
}
