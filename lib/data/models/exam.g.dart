// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) {
  return Exam(
    json['state'] as int,
    json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'state': instance.state,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['Total'] as int,
    (json['Rows'] as List)
        ?.map(
            (e) => e == null ? null : Rows.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'Total': instance.total,
      'Rows': instance.rows,
    };

Rows _$RowsFromJson(Map<String, dynamic> json) {
  return Rows(
    json['ZXBJ'] as bool,
    json['ZXSJ'] as String,
    json['ExamTask'] == null
        ? null
        : ExamTask.fromJson(json['ExamTask'] as Map<String, dynamic>),
    json['ISGB'] as bool,
  );
}

Map<String, dynamic> _$RowsToJson(Rows instance) => <String, dynamic>{
      'ZXBJ': instance.zXBJ,
      'ZXSJ': instance.zXSJ,
      'ExamTask': instance.examTask,
      'ISGB': instance.iSGB,
    };

ExamTask _$ExamTaskFromJson(Map<String, dynamic> json) {
  return ExamTask(
    json['PKZT'] as int,
    json['KSLX'] as int,
    json['PKFS'] as int,
    json['ISTYZJK'] as bool,
    json['ExamPlan'] == null
        ? null
        : ExamPlan.fromJson(json['ExamPlan'] as Map<String, dynamic>),
    json['KSXS'] as String,
    json['CKRS'] as int,
    json['YPJKRS'] as int,
    json['FBZT'] as int,
    json['EMKSRWID'] as String,
    json['KSSF'] as String,
    json['BeginLesson'] == null
        ? null
        : BeginLesson.fromJson(json['BeginLesson'] as Map<String, dynamic>),
    json['KSRQ'] as String,
    json['ExamRoom'] == null
        ? null
        : ExamRoom.fromJson(json['ExamRoom'] as Map<String, dynamic>),
    json['KSSC'] as int,
    json['FBSJ_BZ'] as String,
    json['YQJKRS'] as int,
  );
}

Map<String, dynamic> _$ExamTaskToJson(ExamTask instance) => <String, dynamic>{
      'PKZT': instance.pKZT,
      'KSLX': instance.kSLX,
      'PKFS': instance.pKFS,
      'ISTYZJK': instance.iSTYZJK,
      'ExamPlan': instance.examPlan,
      'KSXS': instance.kSXS,
      'CKRS': instance.cKRS,
      'YPJKRS': instance.yPJKRS,
      'FBZT': instance.fBZT,
      'EMKSRWID': instance.eMKSRWID,
      'KSSF': instance.kSSF,
      'BeginLesson': instance.beginLesson,
      'KSRQ': instance.kSRQ,
      'ExamRoom': instance.examRoom,
      'KSSC': instance.kSSC,
      'FBSJ_BZ': instance.fBSJBZ,
      'YQJKRS': instance.yQJKRS,
    };

ExamPlan _$ExamPlanFromJson(Map<String, dynamic> json) {
  return ExamPlan(
    json['JSRQ'] as String,
    json['JYBJ'] as bool,
    json['ISXSKBSJPD'] as bool,
    json['ISXSKSSJPD'] as bool,
    json['XQBH'] as String,
    json['JHBH'] as String,
    json['JHMC'] as String,
    json['KSRQ'] as String,
  );
}

Map<String, dynamic> _$ExamPlanToJson(ExamPlan instance) => <String, dynamic>{
      'JSRQ': instance.jSRQ,
      'JYBJ': instance.jYBJ,
      'ISXSKBSJPD': instance.iSXSKBSJPD,
      'ISXSKSSJPD': instance.iSXSKSSJPD,
      'XQBH': instance.xQBH,
      'JHBH': instance.jHBH,
      'JHMC': instance.jHMC,
      'KSRQ': instance.kSRQ,
    };

BeginLesson _$BeginLessonFromJson(Map<String, dynamic> json) {
  return BeginLesson(
    json['SHZT'] as int,
    json['ISJZPK'] as bool,
    json['LessonInfo'] == null
        ? null
        : LessonInfo.fromJson(json['LessonInfo'] as Map<String, dynamic>),
    json['ClearZDJS'] as bool,
    json['XXJD'] as double,
    json['PKZT'] as int,
    json['LCKKXXID'] as String,
    json['ISPKYSD'] as bool,
    json['BJRS'] as int,
    json['QZ'] as int,
    json['V_REF_JXJSZ'] as int,
    json['KSXZ'] as String,
    json['ClearKCFZ'] as bool,
    json['ISJZCJLR'] as bool,
    json['ISXKBJ'] as bool,
    json['V_REF_JXKSZ'] as int,
    json['V_REF_PKZXS'] as double,
    json['ClearRKJS'] as bool,
    json['PKFS'] as int,
    json['ClearZDFQ'] as bool,
    json['ISZRXK'] as bool,
    json['ClearBJFZ'] as bool,
    json['XXLB'] as int,
    json['Department'] == null
        ? null
        : Department.fromJson(json['Department'] as Map<String, dynamic>),
    json['LessonOccupyChangeNum'] as int,
    json['V_REF_WXSS'] as int,
    json['JXBLX_CXBM'] as String,
    json['ISKSXK'] as bool,
    json['ClearCJLRJS'] as bool,
    json['ISPKBJ'] as bool,
    json['YPKCS'] as int,
    json['ISZRPK'] as bool,
  );
}

Map<String, dynamic> _$BeginLessonToJson(BeginLesson instance) =>
    <String, dynamic>{
      'SHZT': instance.sHZT,
      'ISJZPK': instance.iSJZPK,
      'LessonInfo': instance.lessonInfo,
      'ClearZDJS': instance.clearZDJS,
      'XXJD': instance.xXJD,
      'PKZT': instance.pKZT,
      'LCKKXXID': instance.lCKKXXID,
      'ISPKYSD': instance.iSPKYSD,
      'BJRS': instance.bJRS,
      'QZ': instance.qZ,
      'V_REF_JXJSZ': instance.vREFJXJSZ,
      'KSXZ': instance.kSXZ,
      'ClearKCFZ': instance.clearKCFZ,
      'ISJZCJLR': instance.iSJZCJLR,
      'ISXKBJ': instance.iSXKBJ,
      'V_REF_JXKSZ': instance.vREFJXKSZ,
      'V_REF_PKZXS': instance.vREFPKZXS,
      'ClearRKJS': instance.clearRKJS,
      'PKFS': instance.pKFS,
      'ClearZDFQ': instance.clearZDFQ,
      'ISZRXK': instance.iSZRXK,
      'ClearBJFZ': instance.clearBJFZ,
      'XXLB': instance.xXLB,
      'Department': instance.department,
      'LessonOccupyChangeNum': instance.lessonOccupyChangeNum,
      'V_REF_WXSS': instance.vREFWXSS,
      'JXBLX_CXBM': instance.jXBLXCXBM,
      'ISKSXK': instance.iSKSXK,
      'ClearCJLRJS': instance.clearCJLRJS,
      'ISPKBJ': instance.iSPKBJ,
      'YPKCS': instance.yPKCS,
      'ISZRPK': instance.iSZRPK,
    };

LessonInfo _$LessonInfoFromJson(Map<String, dynamic> json) {
  return LessonInfo(
    json['KCBH'] as String,
    json['JYBJ'] as bool,
    json['KCMC'] as String,
  );
}

Map<String, dynamic> _$LessonInfoToJson(LessonInfo instance) =>
    <String, dynamic>{
      'KCBH': instance.kCBH,
      'JYBJ': instance.jYBJ,
      'KCMC': instance.kCMC,
    };

Department _$DepartmentFromJson(Map<String, dynamic> json) {
  return Department(
    json['ISSYS'] as bool,
    json['ISGLBM'] as bool,
    json['JYBJ'] as bool,
    json['DWMC'] as String,
    json['ISJYS'] as bool,
    json['ISSKDW'] as bool,
    json['ISSTBJ'] as bool,
    json['DWBH'] as String,
    json['ISKKDW'] as bool,
  );
}

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'ISSYS': instance.iSSYS,
      'ISGLBM': instance.iSGLBM,
      'JYBJ': instance.jYBJ,
      'DWMC': instance.dWMC,
      'ISJYS': instance.iSJYS,
      'ISSKDW': instance.iSSKDW,
      'ISSTBJ': instance.iSSTBJ,
      'DWBH': instance.dWBH,
      'ISKKDW': instance.iSKKDW,
    };

ExamRoom _$ExamRoomFromJson(Map<String, dynamic> json) {
  return ExamRoom(
    json['KSRNRS'] as int,
    json['AssignNum'] as int,
    json['IsTaskAssgin'] as bool,
    json['BPKBJ'] as bool,
    json['AssignClassNum'] as int,
    json['IsLessonAssgin'] as bool,
    json['IsCompleteAssgin'] as bool,
    json['IsFull'] as bool,
    json['IsConflict'] as bool,
    json['KCMC'] as String,
    json['AssignLessonNum'] as int,
    json['RemainNum'] as int,
    json['IsPlanAssign'] as bool,
  );
}

Map<String, dynamic> _$ExamRoomToJson(ExamRoom instance) => <String, dynamic>{
      'KSRNRS': instance.kSRNRS,
      'AssignNum': instance.assignNum,
      'IsTaskAssgin': instance.isTaskAssgin,
      'BPKBJ': instance.bPKBJ,
      'AssignClassNum': instance.assignClassNum,
      'IsLessonAssgin': instance.isLessonAssgin,
      'IsCompleteAssgin': instance.isCompleteAssgin,
      'IsFull': instance.isFull,
      'IsConflict': instance.isConflict,
      'KCMC': instance.kCMC,
      'AssignLessonNum': instance.assignLessonNum,
      'RemainNum': instance.remainNum,
      'IsPlanAssign': instance.isPlanAssign,
    };
