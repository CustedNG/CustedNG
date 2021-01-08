import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:custed2/core/user/cust_user.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/models/grade_detail.dart';
import 'package:custed2/data/models/grade_term.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:flutter/foundation.dart';

class UndergraduateUser with CustUser implements User {
  final _jw = locator<JwService>();

  @override
  Future<Schedule> getSchdeule() async {
    final rawSchedule = await _jw.getSchedule();
    return normalizeSchedule(rawSchedule);
  }

  @override
  Future<Grade> getGrade() async {
    final rawGrade = await _jw.getGrade();
    return normalizeGrade(rawGrade);
  }

  static Future<Schedule> normalizeSchedule(JwSchedule raw) async {
    final result = Schedule()
      ..createdAt = DateTime.now()
      ..versionHash = await computeJsonHashAsync(raw)
      ..startDate = getScheduleStartTime()
      ..lessons = [];

    for (var day in raw.AdjustDays) {
      for (var section in day.allSections()) {
        for (var rawLesson in section.Dtos) {
          final lesson = ScheduleLesson()
            ..weeks = rawLesson.parseWeeks()
            ..name = rawLesson.getName()
            ..classes = rawLesson?.Classs?.map((c) => c.Name)?.toList()
            ..startTime = section.StartTime
            ..endTime = section.EndTime
            ..type = ScheduleLessonType.general
            ..weekday = day.WIndex
            ..classRaw = ''
            ..startSection = section.StartSection
            ..endSection = section.EndSection
            ..roomRaw = rawLesson.getRoom()
            ..teacherName = rawLesson.getTeacher()
            ..classRaw = rawLesson.LessonObjName;
          result.lessons.add(lesson);
        }
      }
    }

    return result;
  }

  static bool isElectiveCourse(GradeDetail grade) {
    return grade.lessonType != '选修';
  }

  static Future<Grade> normalizeGrade(JwGradeData raw) async {
    final termSet = raw.GradeList.map((e) => e.KSXNXQ).toSet();
    final terms = termSet.map((term) {
      final grades = <GradeDetail>[];
      final rawGrades = raw.GradeList.where((g) => g.KSXNXQ == term);
      final effectiveGrades = <String, GradeDetail>{};

      for (var rawGrade in rawGrades) {
        final grade = GradeDetail()
          ..year = rawGrade.KSXNXQ
          ..testStatus = rawGrade.KSZT
          ..lessonType = rawGrade.KCXZ
          ..schoolHour = rawGrade.XS
          ..credit = rawGrade.XF
          ..mark = rawGrade.YXCJ
          ..rawMark = rawGrade.ShowYXCJ
          ..lessonName = rawGrade.LessonInfo.KCMC
          ..testType = rawGrade.KSXZ
          ..lessonCategory = rawGrade.LessonClass.FLMC;

        final key = '${grade.year}:'
            '${grade.lessonName}:'
            '${grade.lessonType}:'
            '${grade.lessonCategory}'
            '${grade.credit}:'
            '${grade.schoolHour}';

        final shouldOverride = effectiveGrades[key] == null ||
            effectiveGrades[key].mark == null ||
            effectiveGrades[key].mark < (grade.mark ?? 0.0);

        if (shouldOverride) {
          effectiveGrades[key] = grade;
        }

        grades.add(grade);
      }

      double weightedGradePointSum = 0.0;
      double creditTotal = 0.0;
      double creditEarned = 0.0;
      int subjectCount = 0;
      int subjectPassed = 0;

      double weightedGradePointSumNoElectiveCourse = 0.0;
      double creditTotalNoElectiveCourse = 0.0;

      for (var grade in effectiveGrades.values) {
        final passed = grade.testStatus == '正常' && grade.mark >= 60;
        final gradePoint = markToGradePoint(grade.mark);
        creditTotal += grade.credit;
        subjectCount += 1;
        if (passed) {
          creditEarned += grade.credit;
          subjectPassed += 1;
        }
        weightedGradePointSum += gradePoint * grade.credit;

        if (isElectiveCourse(grade)) {
          weightedGradePointSumNoElectiveCourse += gradePoint * grade.credit;
          creditTotalNoElectiveCourse += grade.credit;
        }
      }

      final averageGradePoint = weightedGradePointSum / creditTotal;
      final averageGradePointNoElectiveCourse =
          weightedGradePointSumNoElectiveCourse / creditTotalNoElectiveCourse;
      return GradeTerm()
        ..averageGradePoint = averageGradePoint
        ..averageGradePointNoElectiveCourse = averageGradePointNoElectiveCourse
        ..creditTotal = creditTotal
        ..creditEarned = creditEarned
        ..subjectCount = subjectCount
        ..subjectPassed = subjectPassed
        ..grades = grades
        ..termName = term;
    }).toList();

    terms.sort((t1, t2) => t1.termName.compareTo(t2.termName));

    final result = Grade()
      ..createdAt = DateTime.now()
      ..versionHash = await computeJsonHashAsync(raw)
      ..averageGradePoint = raw.GradeStatistics.PJJD
      ..creditEarned = raw.GradeStatistics.SDXF
      ..creditUnattained = raw.GradeStatistics.WTGXF
      ..subjectCount = raw.GradeStatistics.SXMS
      ..subjectPassed = raw.GradeStatistics.TGMS
      ..subjectNotPassed = raw.GradeStatistics.WTGMS
      ..resitCount = raw.GradeStatistics.BKCS
      ..retakeCount = raw.GradeStatistics.CXCS
      ..terms = terms;

    return result;
  }

  static double markToGradePoint(double mark) {
    return mark >= 60 ? (mark - 50) / 10 : 0;
  }

  static String computeJsonHash(dynamic raw) {
    final hash = sha1.convert(utf8.encode(json.encode(raw))).bytes;
    return 'b${BuildData.build}/' + hex.encode(hash);
  }

  static Future<String> computeJsonHashAsync(dynamic raw) {
    return compute(computeJsonHash, raw);
  }

  static DateTime getScheduleStartTime() {
    // This is hardcoded, don't forget to update this :)
    final table = {
      '20201': DateTime(2020, 2, 24),
      '20202': DateTime(2020, 8, 31),
    };

    final year = DateTime.now().year.toString();
    final nth = DateTime.now().month >= 8 ? 2 : 1;

    return table['$year$nth'] ?? table.values.last;
  }
}
