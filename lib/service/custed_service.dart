import 'dart:convert';

import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_response.dart';
import 'package:custed2/data/models/custed_update.dart';
import 'package:custed2/data/models/custed_weather.dart';

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.xuty.cc';
  static const defaultTimeout = Duration(seconds: 100);

  Future<WeatherData> getWeather() async {
    final resp = await get('$baseUrl/app/weather', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return WeatherData.fromJson(custedResp.data as Map<String, dynamic>);
  }

  Future<List<String>> getHotfix() async {
    final resp = await get('$baseUrl/app/hotfix', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return List<String>.from(custedResp.data);
  }

  Future<CustedUpdate> getUpdate() async {
    final resp = await get('$baseUrl/app/apk/newest', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    if (custedResp.hasError) return null;
    return CustedUpdate.fromJson(custedResp.data as Map<String, dynamic>);
  }

  static String getUpdateUrl(CustedUpdate update) =>
      '$baseUrl${update.file.url}';
}
