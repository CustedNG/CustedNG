// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleLessonTypeAdapter extends TypeAdapter<ScheduleLessonType> {
  @override
  final typeId = 1;

  @override
  ScheduleLessonType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScheduleLessonType.general;
      case 1:
        return ScheduleLessonType.experiment;
      case 2:
        return ScheduleLessonType.madeUp;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, ScheduleLessonType obj) {
    switch (obj) {
      case ScheduleLessonType.general:
        writer.writeByte(0);
        break;
      case ScheduleLessonType.experiment:
        writer.writeByte(1);
        break;
      case ScheduleLessonType.madeUp:
        writer.writeByte(2);
        break;
    }
  }
}

class ScheduleLessonAdapter extends TypeAdapter<ScheduleLesson> {
  @override
  final typeId = 0;

  @override
  ScheduleLesson read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleLesson()
      ..name = fields[0] as String
      ..teacherName = fields[1] as String
      ..roomRaw = fields[2] as String
      ..room = fields[3] as String
      ..roomAnnotation = fields[4] as String
      ..type = fields[5] as ScheduleLessonType
      ..classRaw = fields[6] as String
      ..classes = (fields[7] as List)?.cast<String>()
      ..classSize = fields[8] as int
      ..weeks = (fields[9] as List)?.cast<int>()
      ..weekday = fields[10] as int
      ..startSection = fields[11] as int
      ..endSection = fields[12] as int
      ..startTime = fields[13] as String
      ..endTime = fields[14] as String;
  }

  @override
  void write(BinaryWriter writer, ScheduleLesson obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.teacherName)
      ..writeByte(2)
      ..write(obj.roomRaw)
      ..writeByte(3)
      ..write(obj.room)
      ..writeByte(4)
      ..write(obj.roomAnnotation)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.classRaw)
      ..writeByte(7)
      ..write(obj.classes)
      ..writeByte(8)
      ..write(obj.classSize)
      ..writeByte(9)
      ..write(obj.weeks)
      ..writeByte(10)
      ..write(obj.weekday)
      ..writeByte(11)
      ..write(obj.startSection)
      ..writeByte(12)
      ..write(obj.endSection)
      ..writeByte(13)
      ..write(obj.startTime)
      ..writeByte(14)
      ..write(obj.endTime);
  }
}
