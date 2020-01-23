import 'package:custed2/data/models/jw_schedule_for_day.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_photo_blob.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwPhotoBlob {
  JwPhotoBlob();

  String ID;

  // : "2xxxxxxxxxxxxxx.jpg"
  String FileName;

  // : "/9j/4QAYRXh...""
  String Base64String;

  // : null
  String FilePath;

  factory JwPhotoBlob.fromJson(Map<String, dynamic> json) =>
      _$JwPhotoBlobFromJson(json);

  Map<String, dynamic> toJson() => _$JwPhotoBlobToJson(this);

}
