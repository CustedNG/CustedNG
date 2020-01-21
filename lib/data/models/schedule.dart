import 'package:custed2/data/models/schedule_lesson.dart';
import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 3)
class Schedule {
  @HiveField(0)
  List<ScheduleLesson> lessons;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  String versionHash;

  @HiveField(3)
  DateTime startDate;
}
