import 'dart:convert';

import 'package:custed2/core/service/cat_client.dart';
import 'package:custed2/data/models/custed_response.dart';
import 'package:custed2/data/models/custed_weather.dart';

class CustedService extends CatClient {
  static const baseUrl = 'https://cust.xuty.cc';
  static const defaultTimeout = Duration(seconds: 100);

  Future<WeatherData> getWeather() async {
    final resp = await get('$baseUrl/app/weather', timeout: defaultTimeout);
    final custedResp = CustedResponse.fromJson(json.decode(resp.body));
    return WeatherData.fromJson(custedResp.data as Map<String, dynamic>);
  }
}