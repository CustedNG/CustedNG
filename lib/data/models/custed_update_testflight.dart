import 'package:json_annotation/json_annotation.dart';

part 'custed_update_testflight.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class CustedUpdateiOS {
  CustedUpdateiOS();

  /// 最低版本，低于此版本每次启动均提示更新
  int min;

  /// 最新版本
  int newest;
  
  /// Testflight链接地址, 依次尝试打开 直到打开为止
  List<String> urls;
  
  /// alert title
  String title;

  /// alert content
  String content;

  factory CustedUpdateiOS.fromJson(Map<String, dynamic> json) =>
      _$CustedUpdateTestflightFromJson(json);

  Map<String, dynamic> toJson() => _$CustedUpdateTestflightToJson(this);

  @override
  String toString() {
    return 'ios_${newest}_$urls';
  }
}
