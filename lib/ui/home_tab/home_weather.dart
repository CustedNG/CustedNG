import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeWeather extends StatefulWidget {
  HomeWeather();

  @override
  _HomeWeatherState createState() => _HomeWeatherState();
}

class _HomeWeatherState extends State<HomeWeather> {
  bool showCurrent = false;

  @override
  Widget build(BuildContext context) {
    final weather = Provider.of<WeatherProvider>(context);

    final content = showCurrent
        ? _buildCurrent(weather.data?.wendu)
        : _buildWeather(weather.data);

    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: content,
      onPressed: () {
        setState(() => showCurrent = !showCurrent);
      },
    );
  }

  _buildWeather(WeatherData data) {
    return NavbarMiddle(
      textAbove: data != null ? '${data?.city} ${data?.type}' : '加载中...',
      textBelow: '${data?.today?.lowNum ?? ''} ~ ${data?.today?.highNum ?? ''}',
    );
  }

  _buildCurrent(String temperature) {
    return NavbarMiddle(
      textAbove: '当前',
      textBelow: '${temperature ?? ''}℃',
    );
  }
}
