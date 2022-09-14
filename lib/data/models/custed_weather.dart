import 'package:json_annotation/json_annotation.dart';

part 'custed_weather.g.dart';

@JsonSerializable()
class WeatherZhishu {
  WeatherZhishu();

  String name;
  String value;
  String detail;

  factory WeatherZhishu.fromJson(Map<String, dynamic> json) =>
      _$WeatherZhishuFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherZhishuToJson(this);
}

@JsonSerializable()
class WeatherZhishus {
  WeatherZhishus();

  List<WeatherZhishu> zhishu;

  factory WeatherZhishus.fromJson(Map<String, dynamic> json) =>
      _$WeatherZhishusFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherZhishusToJson(this);
}

@JsonSerializable()
class WeatherDetail {
  WeatherDetail();

  String type;
  String fengxiang;
  String fengli;

  factory WeatherDetail.fromJson(Map<String, dynamic> json) =>
      _$WeatherDetailFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDetailToJson(this);
}

@JsonSerializable()
class WeatherForDay {
  WeatherForDay();

  String date;
  String high;
  String low;
  WeatherDetail day;
  WeatherDetail night;

  String get highNum => high.split(' ')[1];
  String get lowNum => low.split(' ')[1];

  factory WeatherForDay.fromJson(Map<String, dynamic> json) =>
      _$WeatherForDayFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForDayToJson(this);
}

@JsonSerializable()
class WeatherForecast {
  WeatherForecast(this.weather);

  List<WeatherForDay> weather;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}

@JsonSerializable()
class WeatherData {
  WeatherData();

  String city;

  @JsonKey(name: 'updatetime')
  String updateTime;

  String wendu;
  // Map<String, dynamic> fengli;
  String shidu;
  String fengxiang;
  String sunrise1;
  String sunset1;
  WeatherForecast forecast;
  WeatherZhishus zhishus;

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);

  WeatherForDay get today => forecast.weather.first;

  String get type =>
      DateTime.now().hour < 18 ? today.day.type : today.night.type;

  WeatherZhishu getZhishu(String keyword) {
    for (var zhishu in zhishus.zhishu) {
      if (zhishu.name.contains(keyword)) {
        return zhishu;
      }
    }
    return null;
  }

  @override
  String toString() {
    return '$updateTime $wendu℃';
  }
}
