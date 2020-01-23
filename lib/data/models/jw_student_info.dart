import 'package:custed2/data/models/jw_photo_blob.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_student_info.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwStudentInfo {
  JwStudentInfo();
  
  /// : "18xxxxxxxxxxxxx"
  String KSH;
  
  /// : "18xxxxxxx"
  String XH;
  
  /// : "某某某"
  String XM;
  
  /// : "Xx YxZxx"
  String YWMC;
  
  /// : "XxYxxZxxx"
  String XMPY;
  
  /// : "XYZ"
  String PYSZM;
  
  /// : "男"
  String XB;
  
  /// : "汉族"
  String MZ;
  
  /// : "共青团员"
  String ZZMM;

  /// : "良好"
  String JKZK;
  
  /// : "身份证"
  String ZJLX;
  
  /// : "21xxxxxxxxxxxxxxxxxxxxxxxx"
  String ZJHM;
  
  /// : "英语"
  String WYYZ;
  
  /// : "普通全日制"
  String XXXS;
  
  /// : "本科批"
  String LQPC;
  
  /// : "普通本科"
  String PYCC;
  
  /// : "2018-09-01 00:00:00"
  String RXRQ;
  
  /// : "统招"
  String RXFS;
  
  /// : "2018"
  String RXNF;
  
  /// : "在籍在校"
  String XJZT;
  
  /// : "转专业"
  String YDZT;
  
  /// : "201800xxxx"
  String YKTH;
  
  /// : "15"
  String BNXH;
  
  /// : "2018年9月21日，xxxxx选拔，原学号xxxx，"
  String BZ1;
  String BZ2;
  
  JwPhotoBlob XJZPBlob;
  
  factory JwStudentInfo.fromJson(Map<String, dynamic> json) =>
      _$JwStudentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$JwStudentInfoToJson(this);

}
