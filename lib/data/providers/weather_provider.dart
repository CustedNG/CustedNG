import 'dart:async';

import 'package:custed2/core/provider/busy_provider.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';

class WeatherProvider extends BusyProvider {
  WeatherData _data;
  WeatherData get data => _data;

  Timer _updateTimer;

  void startAutoUpdate() {
    if (_updateTimer != null) return;
    update();
    _updateTimer = Timer.periodic(Duration(hours: 2), (_) => update());
  }

  void stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  Future<void> update() async {
    final custed = locator<CustedService>();
    _data = await custed.getWeather();

    if (_data != null) {
      print('updated weather data: $_data');
      notifyListeners();
    }
  }

  WeatherForDay get today {
    if (_data?.forecast?.weather == null) return null;
    if (_data.forecast.weather.isEmpty) return null;
    return _data.forecast.weather.first;
  }
}
