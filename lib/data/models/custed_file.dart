import 'package:json_annotation/json_annotation.dart';

part 'custed_file.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class CustedFile {
  CustedFile();

  double size;
  String url;
  String sha256;

  factory CustedFile.fromJson(Map<String, dynamic> json) =>
      _$CustedFileFromJson(json);

  Map<String, dynamic> toJson() => _$CustedFileToJson(this);
}
