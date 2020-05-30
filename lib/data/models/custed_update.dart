import 'package:custed2/data/models/custed_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custed_update.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class CustedUpdate {
  CustedUpdate();

  /// build 号，和git commit对应
  int build;

  /// 更新级别，2表示紧急更新
  int level;
  
  String name;
  String changelog;
  CustedFile file;

  factory CustedUpdate.fromJson(Map<String, dynamic> json) =>
      _$CustedUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$CustedUpdateToJson(this);

  @override
  String toString() {
    return '${name}_$build';
  }
}
