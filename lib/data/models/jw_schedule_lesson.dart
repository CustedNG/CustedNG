import 'package:custed2/data/models/jw_schedule_class.dart';
import 'package:custed2/data/models/jw_schedule_for_day.dart';
import 'package:custed2/data/models/jw_schedule_lesson_prop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_schedule_lesson.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwScheduleLesson {
  JwScheduleLesson();

  String BeginLessonID;
  String LessonObjName;
  String LessonOccupyID;
  List<JwScheduleClass> Classs;
  List<JwScheduleLessonProperty> Content;
  int QueryType;

  factory JwScheduleLesson.fromJson(Map<String, dynamic> json) =>
      _$JwScheduleLessonFromJson(json);

  Map<String, dynamic> toJson() => _$JwScheduleLessonToJson(this);

  String getProp(String key) {
    for (var prop in Content) {
      if (prop.Key == key) {
        return prop.Name;
      }
    }
    return null;
  }

  String getName() => getProp('Lesson');
  String getTeacher() => getProp('Teacher');
  String getRoom() => getProp('Room');
  String getWeeks() => getProp('Time');

  List<int> parseWeeks() {
    final result = <int>[];

    final rawWeeks = getWeeks();
    final weeks = rawWeeks.replaceAll(RegExp(r'[^0-9,-]'), '');

    for (var part in weeks.split(',')) {
      if (weeks.contains('-')) {
        final splited = weeks.split('-');
        final start = int.parse(splited[0]);
        final end = int.parse(splited[1]);
        result.addAll(List.generate(end - start + 1, (i) => i + start));
      } else {
        result.add(int.parse(part));
      }
    }

    // In case some novice operator don't know what '单周' means.
    if (result.length > 1) {
      if (rawWeeks.contains('单周')) result.retainWhere(_oddWeekFilter);
      if (rawWeeks.contains('双周')) result.retainWhere(_evenWeekFilter);
    }

    return result;
  }

  static bool _oddWeekFilter(int week) => (week % 2) != 0;
  static bool _evenWeekFilter(int week) => (week % 2) == 0;

  @override
  String toString() {
    return '${getName()}(${getRoom()}|${getTeacher() ?? '无教师信息'})';
  }
}
