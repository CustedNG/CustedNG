// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_photo_blob.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwPhotoBlob _$JwPhotoBlobFromJson(Map<String, dynamic> json) {
  return JwPhotoBlob()
    ..ID = json['ID'] as String
    ..FileName = json['FileName'] as String
    ..Base64String = json['Base64String'] as String
    ..FilePath = json['FilePath'] as String;
}

Map<String, dynamic> _$JwPhotoBlobToJson(JwPhotoBlob instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'FileName': instance.FileName,
      'Base64String': instance.Base64String,
      'FilePath': instance.FilePath,
    };
