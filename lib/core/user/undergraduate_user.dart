import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/grade.dart';
import 'package:custed2/data/models/grade_detail.dart';
import 'package:custed2/data/models/jw_grade_data.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:custed2/service/mysso_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class UndergraduateUser implements User {
  final _jw = locator<JwService>();
  final _mysso = locator<MyssoService>();

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

  @override
  Future<UserProfile> getProfile() async {
    final profile = await _mysso.getProfile();
    return UserProfile()
      ..displayName = profile.name
      ..department = 'Null 学院';
  }

  @override
  Future<ImageProvider> getAvatar() async => ImageRes.defaultAvatar;

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
            ..classes = rawLesson.Classs.map((c) => c.Name).toList()
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

  static Future<Grade> normalizeGrade(JwGradeData raw) async {
    final grades = raw.GradeList.map((rawGrade) {
      return GradeDetail()
        ..year = rawGrade.KSXNXQ
        ..testStatus = rawGrade.KSZT
        ..lessonType = rawGrade.KSXNXQ
        ..schoolHour = rawGrade.XS
        ..credit = rawGrade.XF
        ..point = rawGrade.YXCJ
        ..rawPoint = rawGrade.ShowYXCJ
        ..lessonName = rawGrade.LessonInfo.KCMC
        ..testType = rawGrade.KSXZ;
    }).toList();

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
      ..grades = grades;

    return result;
  }

  static String computeJsonHash(dynamic raw) {
    final hash = sha1.convert(utf8.encode(json.encode(raw))).bytes;
    return hex.encode(hash);
  }

  static Future<String> computeJsonHashAsync(dynamic raw) {
    return compute(computeJsonHash, raw);
  }

  static DateTime getScheduleStartTime() {
    // This is hardcoded, don't forget to update this :)
    final table = {
      '20202': DateTime(2020, 2, 24),
    };

    final year = DateTime.now().year.toString();
    final nth = DateTime.now().month > 6 ? 1 : 2;

    return table['$year$nth'];
  }
}
