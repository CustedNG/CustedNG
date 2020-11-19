import 'package:json_annotation/json_annotation.dart';

part 'jw_exam.g.dart';


@JsonSerializable()
class JwExam extends Object {

  @JsonKey(name: 'state')
  int state;

  @JsonKey(name: 'data')
  JwExamData data;

  JwExam(this.state,this.data,);

  factory JwExam.fromJson(Map<String, dynamic> srcJson) => _$JwExamFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamToJson(this);

}


@JsonSerializable()
class JwExamData extends Object {

  @JsonKey(name: 'Total')
  int total;

  @JsonKey(name: 'Rows')
  List<JwExamRows> rows;

  JwExamData(this.total,this.rows,);

  factory JwExamData.fromJson(Map<String, dynamic> srcJson) => _$JwExamDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamDataToJson(this);

}


@JsonSerializable()
class JwExamRows extends Object {

  @JsonKey(name: 'ZXBJ')
  bool zXBJ;

  @JsonKey(name: 'ZXSJ')
  String zXSJ;

  @JsonKey(name: 'ExamTask')
  JwExamTask examTask;

  @JsonKey(name: 'ISGB')
  bool iSGB;

  JwExamRows(this.zXBJ,this.zXSJ,this.examTask,this.iSGB,);

  factory JwExamRows.fromJson(Map<String, dynamic> srcJson) => _$JwExamRowsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamRowsToJson(this);

}


@JsonSerializable()
class JwExamTask extends Object {

  @JsonKey(name: 'PKZT')
  int pKZT;

  @JsonKey(name: 'KSLX')
  int kSLX;

  @JsonKey(name: 'PKFS')
  int pKFS;

  @JsonKey(name: 'ISTYZJK')
  bool iSTYZJK;

  @JsonKey(name: 'ExamPlan')
  JwExamPlan examPlan;

  @JsonKey(name: 'KSXS')
  String type;

  @JsonKey(name: 'CKRS')
  int cKRS;

  @JsonKey(name: 'YPJKRS')
  int yPJKRS;

  @JsonKey(name: 'FBZT')
  int fBZT;

  @JsonKey(name: 'EMKSRWID')
  String eMKSRWID;

  @JsonKey(name: 'KSSF')
  String time;

  @JsonKey(name: 'BeginLesson')
  JwExamBeginLesson beginLesson;

  @JsonKey(name: 'KSRQ')
  String date;

  @JsonKey(name: 'ExamRoom')
  JwExamRoom examRoom;

  @JsonKey(name: 'KSSC')
  int kSSC;

  @JsonKey(name: 'FBSJ_BZ')
  String fBSJBZ;

  @JsonKey(name: 'YQJKRS')
  int yQJKRS;

  JwExamTask(this.pKZT,this.kSLX,this.pKFS,this.iSTYZJK,this.examPlan,this.type,this.cKRS,this.yPJKRS,this.fBZT,this.eMKSRWID,this.time,this.beginLesson,this.date,this.examRoom,this.kSSC,this.fBSJBZ,this.yQJKRS,);

  factory JwExamTask.fromJson(Map<String, dynamic> srcJson) => _$JwExamTaskFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamTaskToJson(this);

}


@JsonSerializable()
class JwExamPlan extends Object {

  @JsonKey(name: 'JSRQ')
  String jSRQ;

  @JsonKey(name: 'JYBJ')
  bool jYBJ;

  @JsonKey(name: 'ISXSKBSJPD')
  bool iSXSKBSJPD;

  @JsonKey(name: 'ISXSKSSJPD')
  bool iSXSKSSJPD;

  @JsonKey(name: 'XQBH')
  String xQBH;

  @JsonKey(name: 'JHBH')
  String jHBH;

  @JsonKey(name: 'JHMC')
  String jHMC;

  @JsonKey(name: 'KSRQ')
  String kSRQ;

  JwExamPlan(this.jSRQ,this.jYBJ,this.iSXSKBSJPD,this.iSXSKSSJPD,this.xQBH,this.jHBH,this.jHMC,this.kSRQ,);

  factory JwExamPlan.fromJson(Map<String, dynamic> srcJson) => _$JwExamPlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamPlanToJson(this);

}


@JsonSerializable()
class JwExamBeginLesson extends Object {

  @JsonKey(name: 'SHZT')
  int sHZT;

  @JsonKey(name: 'ISJZPK')
  bool iSJZPK;

  @JsonKey(name: 'LessonInfo')
  JwExamLessonInfo lessonInfo;

  @JsonKey(name: 'ClearZDJS')
  bool clearZDJS;

  @JsonKey(name: 'XXJD')
  double xXJD;

  @JsonKey(name: 'PKZT')
  int pKZT;

  @JsonKey(name: 'LCKKXXID')
  String lCKKXXID;

  @JsonKey(name: 'ISPKYSD')
  bool iSPKYSD;

  @JsonKey(name: 'BJRS')
  int bJRS;

  @JsonKey(name: 'QZ')
  int qZ;

  @JsonKey(name: 'V_REF_JXJSZ')
  int vREFJXJSZ;

  @JsonKey(name: 'KSXZ')
  String kSXZ;

  @JsonKey(name: 'ClearKCFZ')
  bool clearKCFZ;

  @JsonKey(name: 'ISJZCJLR')
  bool iSJZCJLR;

  @JsonKey(name: 'ISXKBJ')
  bool iSXKBJ;

  @JsonKey(name: 'V_REF_JXKSZ')
  int vREFJXKSZ;

  @JsonKey(name: 'V_REF_PKZXS')
  double vREFPKZXS;

  @JsonKey(name: 'ClearRKJS')
  bool clearRKJS;

  @JsonKey(name: 'PKFS')
  int pKFS;

  @JsonKey(name: 'ClearZDFQ')
  bool clearZDFQ;

  @JsonKey(name: 'ISZRXK')
  bool iSZRXK;

  @JsonKey(name: 'ClearBJFZ')
  bool clearBJFZ;

  @JsonKey(name: 'XXLB')
  int xXLB;

  @JsonKey(name: 'Department')
  Department department;

  @JsonKey(name: 'LessonOccupyChangeNum')
  int lessonOccupyChangeNum;

  @JsonKey(name: 'V_REF_WXSS')
  int vREFWXSS;

  @JsonKey(name: 'JXBLX_CXBM')
  String jXBLXCXBM;

  @JsonKey(name: 'ISKSXK')
  bool iSKSXK;

  @JsonKey(name: 'ClearCJLRJS')
  bool clearCJLRJS;

  @JsonKey(name: 'ISPKBJ')
  bool iSPKBJ;

  @JsonKey(name: 'YPKCS')
  int yPKCS;

  @JsonKey(name: 'ISZRPK')
  bool iSZRPK;

  JwExamBeginLesson(this.sHZT,this.iSJZPK,this.lessonInfo,this.clearZDJS,this.xXJD,this.pKZT,this.lCKKXXID,this.iSPKYSD,this.bJRS,this.qZ,this.vREFJXJSZ,this.kSXZ,this.clearKCFZ,this.iSJZCJLR,this.iSXKBJ,this.vREFJXKSZ,this.vREFPKZXS,this.clearRKJS,this.pKFS,this.clearZDFQ,this.iSZRXK,this.clearBJFZ,this.xXLB,this.department,this.lessonOccupyChangeNum,this.vREFWXSS,this.jXBLXCXBM,this.iSKSXK,this.clearCJLRJS,this.iSPKBJ,this.yPKCS,this.iSZRPK,);

  factory JwExamBeginLesson.fromJson(Map<String, dynamic> srcJson) => _$JwExamBeginLessonFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamBeginLessonToJson(this);

}


@JsonSerializable()
class JwExamLessonInfo extends Object {

  @JsonKey(name: 'KCBH')
  String kCBH;

  @JsonKey(name: 'JYBJ')
  bool jYBJ;

  @JsonKey(name: 'KCMC')
  String name;

  JwExamLessonInfo(this.kCBH,this.jYBJ,this.name,);

  factory JwExamLessonInfo.fromJson(Map<String, dynamic> srcJson) => _$JwExamLessonInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamLessonInfoToJson(this);

}


@JsonSerializable()
class Department extends Object {

  @JsonKey(name: 'ISSYS')
  bool iSSYS;

  @JsonKey(name: 'ISGLBM')
  bool iSGLBM;

  @JsonKey(name: 'JYBJ')
  bool jYBJ;

  @JsonKey(name: 'DWMC')
  String dWMC;

  @JsonKey(name: 'ISJYS')
  bool iSJYS;

  @JsonKey(name: 'ISSKDW')
  bool iSSKDW;

  @JsonKey(name: 'ISSTBJ')
  bool iSSTBJ;

  @JsonKey(name: 'DWBH')
  String dWBH;

  @JsonKey(name: 'ISKKDW')
  bool iSKKDW;

  Department(this.iSSYS,this.iSGLBM,this.jYBJ,this.dWMC,this.iSJYS,this.iSSKDW,this.iSSTBJ,this.dWBH,this.iSKKDW,);

  factory Department.fromJson(Map<String, dynamic> srcJson) => _$DepartmentFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);

}


@JsonSerializable()
class JwExamRoom extends Object {

  @JsonKey(name: 'KSRNRS')
  int kSRNRS;

  @JsonKey(name: 'AssignNum')
  int assignNum;

  @JsonKey(name: 'IsTaskAssgin')
  bool isTaskAssgin;

  @JsonKey(name: 'BPKBJ')
  bool bPKBJ;

  @JsonKey(name: 'AssignClassNum')
  int assignClassNum;

  @JsonKey(name: 'IsLessonAssgin')
  bool isLessonAssgin;

  @JsonKey(name: 'IsCompleteAssgin')
  bool isCompleteAssgin;

  @JsonKey(name: 'IsFull')
  bool isFull;

  @JsonKey(name: 'IsConflict')
  bool isConflict;

  @JsonKey(name: 'KCMC')
  String name;

  @JsonKey(name: 'AssignLessonNum')
  int assignLessonNum;

  @JsonKey(name: 'RemainNum')
  int remainNum;

  @JsonKey(name: 'IsPlanAssign')
  bool isPlanAssign;

  JwExamRoom(this.kSRNRS,this.assignNum,this.isTaskAssgin,this.bPKBJ,this.assignClassNum,this.isLessonAssgin,this.isCompleteAssgin,this.isFull,this.isConflict,this.name,this.assignLessonNum,this.remainNum,this.isPlanAssign,);

  factory JwExamRoom.fromJson(Map<String, dynamic> srcJson) => _$JwExamRoomFromJson(srcJson);

  Map<String, dynamic> toJson() => _$JwExamRoomToJson(this);

}

