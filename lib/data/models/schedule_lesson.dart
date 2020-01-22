import 'package:hive/hive.dart';

part 'schedule_lesson.g.dart';

@HiveType(typeId: 0)
class ScheduleLesson {
  /// e.g. Linux系统
  @HiveField(0)
  String name;

  /// e.g. 徐晶
  @HiveField(1)
  String teacherName;

  /// e.g. 研706[理论]
  @HiveField(2)
  String roomRaw;

  /// e.g. 研706
  @HiveField(3)
  String room;

  /// e.g. [实践] / [理论]
  @HiveField(4)
  String roomAnnotation;

  /// 课程类型, 见 [ScheduleLessonType]
  @HiveField(5)
  ScheduleLessonType type;

  /// e.g. 1813021-22_实验[65人]
  @HiveField(6)
  String classRaw;

  /// e.g. ['1813021', '1813022']
  @HiveField(7)
  List<String> classes;

  /// e.g. 65
  @HiveField(8)
  int classSize;

  /// e.g. [1, 2, 3, 4]
  @HiveField(9)
  List<int> weeks;

  /// e.g. 1 (周一)
  @HiveField(10)
  int weekday;

  /// e.g. 1
  @HiveField(11)
  int startSection;

  /// e.g. 2
  @HiveField(12)
  int endSection;

  /// e.g. 10:05
  @HiveField(13)
  String startTime;

  /// e.g. 11:40
  @HiveField(14)
  String endTime;

  bool isActiveInWeek(int week) => weeks.contains(week);
}

@HiveType(typeId: 1)
enum ScheduleLessonType {
  /// 普通课, 分为理论和实践
  @HiveField(0)
  general,

  /// 实验课, 时间与普通课不同
  @HiveField(1)
  experiment,

  /// 调课
  @HiveField(2)
  madeUp,
}