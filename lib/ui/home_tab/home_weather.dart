import 'package:custed2/config/routes.dart';
import 'package:custed2/data/models/custed_weather.dart';
import 'package:custed2/data/providers/weather_provider.dart';
import 'package:custed2/ui/widgets/navbar/navbar_middle.dart';
import 'package:flutter/material.dart';
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

    return GestureDetector(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 233),
        child: showCurrent
            ? _buildCurrent(weather.data?.wendu)
            : _buildWeather(weather.data),
      ),
      onTap: () => setState(() => showCurrent = !showCurrent),
      onLongPress: () => debugPage.go(context),
    );
  }

  _buildWeather(WeatherData data) {
    return Container(
      key: ValueKey(1),
      child: NavbarMiddle(
        textAbove: data != null ? '${data?.city} ${data?.type}' : '加载中...',
        textBelow:
            '${data?.today?.lowNum ?? ''} ~ ${data?.today?.highNum ?? ''}',
      ),
    );
  }

  _buildCurrent(String temperature) {
    return Container(
      key: ValueKey(2),
      child: NavbarMiddle(
        textAbove: '当前',
        textBelow: '${temperature ?? ''}℃',
      ),
    );
  }
}
