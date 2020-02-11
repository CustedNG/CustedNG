import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:custed2/core/user/user.dart';
import 'package:custed2/data/models/jw_schedule.dart';
import 'package:custed2/data/models/schedule.dart';
import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:custed2/data/models/user_profile.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/res/image_res.dart';
import 'package:custed2/service/jw_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class UndergraduateUser implements User {
  final _jw = locator<JwService>();

  @override
  Future<Schedule> getSchdeule() async {
    final rawSchedule = await _jw.getSchedule();
    return normalizeSchedule(rawSchedule);
  }

  @override
  Future<UserProfile> getProfile() async {
    final rawProfile = await _jw.getStudentInfo();
    return UserProfile()
      ..displayName = rawProfile.XM
      ..department = 'Null 学院';
  }

  @override
  Future<ImageProvider> getAvatar() async => ImageRes.defaultAvatar;

  static Future<Schedule> normalizeSchedule(JwSchedule raw) async {
    final result = Schedule()
      ..versionHash = await computeScheduleHashAsync(raw)
      ..createdAt = DateTime.now()
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

  static String computeScheduleHash(JwSchedule raw) {
    final hash = sha1.convert(utf8.encode(json.encode(raw))).bytes;
    return hex.encode(hash);
  }

  static Future<String> computeScheduleHashAsync(JwSchedule raw) {
    return compute(computeScheduleHash, raw);
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
