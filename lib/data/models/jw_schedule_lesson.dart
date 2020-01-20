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

  @override
  String toString() {
    return '${getName()}(${getRoom()}|${getTeacher() ?? '无教师信息'})';
  }
}
