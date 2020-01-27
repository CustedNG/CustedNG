// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custed_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherZhishu _$WeatherZhishuFromJson(Map<String, dynamic> json) {
  return WeatherZhishu()
    ..name = json['name'] as String
    ..value = json['value'] as String
    ..detail = json['detail'] as String;
}

Map<String, dynamic> _$WeatherZhishuToJson(WeatherZhishu instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'detail': instance.detail,
    };

WeatherZhishus _$WeatherZhishusFromJson(Map<String, dynamic> json) {
  return WeatherZhishus()
    ..zhishu = (json['zhishu'] as List)
        ?.map((e) => e == null
            ? null
            : WeatherZhishu.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$WeatherZhishusToJson(WeatherZhishus instance) =>
    <String, dynamic>{
      'zhishu': instance.zhishu,
    };

WeatherDetail _$WeatherDetailFromJson(Map<String, dynamic> json) {
  return WeatherDetail()
    ..type = json['type'] as String
    ..fengxiang = json['fengxiang'] as String
    ..fengli = json['fengli'] as String;
}

Map<String, dynamic> _$WeatherDetailToJson(WeatherDetail instance) =>
    <String, dynamic>{
      'type': instance.type,
      'fengxiang': instance.fengxiang,
      'fengli': instance.fengli,
    };

WeatherForDay _$WeatherForDayFromJson(Map<String, dynamic> json) {
  return WeatherForDay()
    ..date = json['date'] as String
    ..high = json['high'] as String
    ..low = json['low'] as String
    ..day = json['day'] == null
        ? null
        : WeatherDetail.fromJson(json['day'] as Map<String, dynamic>)
    ..night = json['night'] == null
        ? null
        : WeatherDetail.fromJson(json['night'] as Map<String, dynamic>);
}

Map<String, dynamic> _$WeatherForDayToJson(WeatherForDay instance) =>
    <String, dynamic>{
      'date': instance.date,
      'high': instance.high,
      'low': instance.low,
      'day': instance.day,
      'night': instance.night,
    };

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) {
  return WeatherForecast(
    (json['weather'] as List)
        ?.map((e) => e == null
            ? null
            : WeatherForDay.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WeatherForecastToJson(WeatherForecast instance) =>
    <String, dynamic>{
      'weather': instance.weather,
    };

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) {
  return WeatherData()
    ..city = json['city'] as String
    ..updateTime = json['updatetime'] as String
    ..wendu = json['wendu'] as String
    ..shidu = json['shidu'] as String
    ..fengxiang = json['fengxiang'] as String
    ..sunrise1 = json['sunrise1'] as String
    ..sunset1 = json['sunset1'] as String
    ..forecast = json['forecast'] == null
        ? null
        : WeatherForecast.fromJson(json['forecast'] as Map<String, dynamic>)
    ..zhishus = json['zhishus'] == null
        ? null
        : WeatherZhishus.fromJson(json['zhishus'] as Map<String, dynamic>);
}

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'city': instance.city,
      'updatetime': instance.updateTime,
      'wendu': instance.wendu,
      'shidu': instance.shidu,
      'fengxiang': instance.fengxiang,
      'sunrise1': instance.sunrise1,
      'sunset1': instance.sunset1,
      'forecast': instance.forecast,
      'zhishus': instance.zhishus,
    };
