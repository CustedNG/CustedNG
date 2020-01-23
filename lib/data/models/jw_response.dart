import 'package:json_annotation/json_annotation.dart';

part 'jw_response.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwResponse {
  JwResponse();
  
  int state;
  String message;
  Map<String, dynamic> data;

  factory JwResponse.fromJson(Map<String, dynamic> json) =>
      _$JwResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JwResponseToJson(this);

  bool get isSuccess => state == 0;
}
