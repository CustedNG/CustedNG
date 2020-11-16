import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';


@JsonSerializable()
class Exam extends Object {

  @JsonKey(name: 'state')
  int state;

  @JsonKey(name: 'data')
  Data data;

  Exam(this.state,this.data,);

  factory Exam.fromJson(Map<String, dynamic> srcJson) => _$ExamFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ExamToJson(this);

}


@JsonSerializable()
class Data extends Object {

  @JsonKey(name: 'Total')
  int total;

  @JsonKey(name: 'Rows')
  List<Rows> rows;

  Data(this.total,this.rows,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


@JsonSerializable()
class Rows extends Object {

  @JsonKey(name: 'ZXBJ')
  bool zXBJ;

  @JsonKey(name: 'ZXSJ')
  String zXSJ;

  @JsonKey(name: 'ExamTask')
  ExamTask examTask;

  @JsonKey(name: 'ISGB')
  bool iSGB;

  Rows(this.zXBJ,this.zXSJ,this.examTask,this.iSGB,);

  factory Rows.fromJson(Map<String, dynamic> srcJson) => _$RowsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RowsToJson(this);

}


@JsonSerializable()
class ExamTask extends Object {

  @JsonKey(name: 'PKZT')
  int pKZT;

  @JsonKey(name: 'KSLX')
  int kSLX;

  @JsonKey(name: 'PKFS')
  int pKFS;

  @JsonKey(name: 'ISTYZJK')
  bool iSTYZJK;

  @JsonKey(name: 'ExamPlan')
  ExamPlan examPlan;

  @JsonKey(name: 'KSXS')
  String kSXS;

  @JsonKey(name: 'CKRS')
  int cKRS;

  @JsonKey(name: 'YPJKRS')
  int yPJKRS;

  @JsonKey(name: 'FBZT')
  int fBZT;

  @JsonKey(name: 'EMKSRWID')
  String eMKSRWID;

  @JsonKey(name: 'KSSF')
  String kSSF;

  @JsonKey(name: 'BeginLesson')
  BeginLesson beginLesson;

  @JsonKey(name: 'KSRQ')
  String kSRQ;

  @JsonKey(name: 'ExamRoom')
  ExamRoom examRoom;

  @JsonKey(name: 'KSSC')
  int kSSC;

  @JsonKey(name: 'FBSJ_BZ')
  String fBSJBZ;

  @JsonKey(name: 'YQJKRS')
  int yQJKRS;

  ExamTask(this.pKZT,this.kSLX,this.pKFS,this.iSTYZJK,this.examPlan,this.kSXS,this.cKRS,this.yPJKRS,this.fBZT,this.eMKSRWID,this.kSSF,this.beginLesson,this.kSRQ,this.examRoom,this.kSSC,this.fBSJBZ,this.yQJKRS,);

  factory ExamTask.fromJson(Map<String, dynamic> srcJson) => _$ExamTaskFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ExamTaskToJson(this);

}


@JsonSerializable()
class ExamPlan extends Object {

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

  ExamPlan(this.jSRQ,this.jYBJ,this.iSXSKBSJPD,this.iSXSKSSJPD,this.xQBH,this.jHBH,this.jHMC,this.kSRQ,);

  factory ExamPlan.fromJson(Map<String, dynamic> srcJson) => _$ExamPlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ExamPlanToJson(this);

}


@JsonSerializable()
class BeginLesson extends Object {

  @JsonKey(name: 'SHZT')
  int sHZT;

  @JsonKey(name: 'ISJZPK')
  bool iSJZPK;

  @JsonKey(name: 'LessonInfo')
  LessonInfo lessonInfo;

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

  BeginLesson(this.sHZT,this.iSJZPK,this.lessonInfo,this.clearZDJS,this.xXJD,this.pKZT,this.lCKKXXID,this.iSPKYSD,this.bJRS,this.qZ,this.vREFJXJSZ,this.kSXZ,this.clearKCFZ,this.iSJZCJLR,this.iSXKBJ,this.vREFJXKSZ,this.vREFPKZXS,this.clearRKJS,this.pKFS,this.clearZDFQ,this.iSZRXK,this.clearBJFZ,this.xXLB,this.department,this.lessonOccupyChangeNum,this.vREFWXSS,this.jXBLXCXBM,this.iSKSXK,this.clearCJLRJS,this.iSPKBJ,this.yPKCS,this.iSZRPK,);

  factory BeginLesson.fromJson(Map<String, dynamic> srcJson) => _$BeginLessonFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BeginLessonToJson(this);

}


@JsonSerializable()
class LessonInfo extends Object {

  @JsonKey(name: 'KCBH')
  String kCBH;

  @JsonKey(name: 'JYBJ')
  bool jYBJ;

  @JsonKey(name: 'KCMC')
  String kCMC;

  LessonInfo(this.kCBH,this.jYBJ,this.kCMC,);

  factory LessonInfo.fromJson(Map<String, dynamic> srcJson) => _$LessonInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LessonInfoToJson(this);

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
class ExamRoom extends Object {

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
  String kCMC;

  @JsonKey(name: 'AssignLessonNum')
  int assignLessonNum;

  @JsonKey(name: 'RemainNum')
  int remainNum;

  @JsonKey(name: 'IsPlanAssign')
  bool isPlanAssign;

  ExamRoom(this.kSRNRS,this.assignNum,this.isTaskAssgin,this.bPKBJ,this.assignClassNum,this.isLessonAssgin,this.isCompleteAssgin,this.isFull,this.isConflict,this.kCMC,this.assignLessonNum,this.remainNum,this.isPlanAssign,);

  factory ExamRoom.fromJson(Map<String, dynamic> srcJson) => _$ExamRoomFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ExamRoomToJson(this);

}

