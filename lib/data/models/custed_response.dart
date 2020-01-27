import 'package:json_annotation/json_annotation.dart';

part 'custed_response.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class CustedResponse {
  CustedResponse();
  
  bool ok;
  dynamic data;

  factory CustedResponse.fromJson(Map<String, dynamic> json) =>
      _$CustedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustedResponseToJson(this);
}
