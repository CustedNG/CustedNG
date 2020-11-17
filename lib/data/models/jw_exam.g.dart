// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jw_exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwExam _$JwExamFromJson(Map<String, dynamic> json) {
  return JwExam(
    json['state'] as int,
    json['data'] == null
        ? null
        : JwExamData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$JwExamToJson(JwExam instance) => <String, dynamic>{
      'state': instance.state,
      'data': instance.data,
    };

JwExamData _$JwExamDataFromJson(Map<String, dynamic> json) {
  return JwExamData(
    json['Total'] as int,
    (json['Rows'] as List)
        ?.map((e) =>
            e == null ? null : JwExamRows.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$JwExamDataToJson(JwExamData instance) =>
    <String, dynamic>{
      'Total': instance.total,
      'Rows': instance.rows,
    };

JwExamRows _$JwExamRowsFromJson(Map<String, dynamic> json) {
  return JwExamRows(
    json['ZXBJ'] as bool,
    json['ZXSJ'] as String,
    json['ExamTask'] == null
        ? null
        : JwExamTask.fromJson(json['ExamTask'] as Map<String, dynamic>),
    json['ISGB'] as bool,
  );
}

Map<String, dynamic> _$JwExamRowsToJson(JwExamRows instance) =>
    <String, dynamic>{
      'ZXBJ': instance.zXBJ,
      'ZXSJ': instance.zXSJ,
      'ExamTask': instance.examTask,
      'ISGB': instance.iSGB,
    };

JwExamTask _$JwExamTaskFromJson(Map<String, dynamic> json) {
  return JwExamTask(
    json['PKZT'] as int,
    json['KSLX'] as int,
    json['PKFS'] as int,
    json['ISTYZJK'] as bool,
    json['ExamPlan'] == null
        ? null
        : JwExamPlan.fromJson(json['ExamPlan'] as Map<String, dynamic>),
    json['KSXS'] as String,
    json['CKRS'] as int,
    json['YPJKRS'] as int,
    json['FBZT'] as int,
    json['EMKSRWID'] as String,
    json['KSSF'] as String,
    json['BeginLesson'] == null
        ? null
        : JwExamBeginLesson.fromJson(
            json['BeginLesson'] as Map<String, dynamic>),
    json['KSRQ'] as String,
    json['ExamRoom'] == null
        ? null
        : JwExamRoom.fromJson(json['ExamRoom'] as Map<String, dynamic>),
    json['KSSC'] as int,
    json['FBSJ_BZ'] as String,
    json['YQJKRS'] as int,
  );
}

Map<String, dynamic> _$JwExamTaskToJson(JwExamTask instance) =>
    <String, dynamic>{
      'PKZT': instance.pKZT,
      'KSLX': instance.kSLX,
      'PKFS': instance.pKFS,
      'ISTYZJK': instance.iSTYZJK,
      'ExamPlan': instance.examPlan,
      'KSXS': instance.type,
      'CKRS': instance.cKRS,
      'YPJKRS': instance.yPJKRS,
      'FBZT': instance.fBZT,
      'EMKSRWID': instance.eMKSRWID,
      'KSSF': instance.beginTime,
      'BeginLesson': instance.beginLesson,
      'KSRQ': instance.beginDate,
      'ExamRoom': instance.examRoom,
      'KSSC': instance.kSSC,
      'FBSJ_BZ': instance.fBSJBZ,
      'YQJKRS': instance.yQJKRS,
    };

JwExamPlan _$JwExamPlanFromJson(Map<String, dynamic> json) {
  return JwExamPlan(
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

Map<String, dynamic> _$JwExamPlanToJson(JwExamPlan instance) =>
    <String, dynamic>{
      'JSRQ': instance.jSRQ,
      'JYBJ': instance.jYBJ,
      'ISXSKBSJPD': instance.iSXSKBSJPD,
      'ISXSKSSJPD': instance.iSXSKSSJPD,
      'XQBH': instance.xQBH,
      'JHBH': instance.jHBH,
      'JHMC': instance.jHMC,
      'KSRQ': instance.kSRQ,
    };

JwExamBeginLesson _$JwExamBeginLessonFromJson(Map<String, dynamic> json) {
  return JwExamBeginLesson(
    json['SHZT'] as int,
    json['ISJZPK'] as bool,
    json['LessonInfo'] == null
        ? null
        : JwExamLessonInfo.fromJson(json['LessonInfo'] as Map<String, dynamic>),
    json['ClearZDJS'] as bool,
    (json['XXJD'] as num)?.toDouble(),
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
    (json['V_REF_PKZXS'] as num)?.toDouble(),
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

Map<String, dynamic> _$JwExamBeginLessonToJson(JwExamBeginLesson instance) =>
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

JwExamLessonInfo _$JwExamLessonInfoFromJson(Map<String, dynamic> json) {
  return JwExamLessonInfo(
    json['KCBH'] as String,
    json['JYBJ'] as bool,
    json['KCMC'] as String,
  );
}

Map<String, dynamic> _$JwExamLessonInfoToJson(JwExamLessonInfo instance) =>
    <String, dynamic>{
      'KCBH': instance.kCBH,
      'JYBJ': instance.jYBJ,
      'KCMC': instance.name,
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

JwExamRoom _$JwExamRoomFromJson(Map<String, dynamic> json) {
  return JwExamRoom(
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

Map<String, dynamic> _$JwExamRoomToJson(JwExamRoom instance) =>
    <String, dynamic>{
      'KSRNRS': instance.kSRNRS,
      'AssignNum': instance.assignNum,
      'IsTaskAssgin': instance.isTaskAssgin,
      'BPKBJ': instance.bPKBJ,
      'AssignClassNum': instance.assignClassNum,
      'IsLessonAssgin': instance.isLessonAssgin,
      'IsCompleteAssgin': instance.isCompleteAssgin,
      'IsFull': instance.isFull,
      'IsConflict': instance.isConflict,
      'KCMC': instance.name,
      'AssignLessonNum': instance.assignLessonNum,
      'RemainNum': instance.remainNum,
      'IsPlanAssign': instance.isPlanAssign,
    };
