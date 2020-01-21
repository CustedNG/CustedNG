// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleAdapter extends TypeAdapter<Schedule> {
  @override
  final typeId = 3;

  @override
  Schedule read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Schedule()
      ..lessons = (fields[0] as List)?.cast<ScheduleLesson>()
      ..createdAt = fields[1] as DateTime
      ..versionHash = fields[2] as String
      ..startDate = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Schedule obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.lessons)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.versionHash)
      ..writeByte(3)
      ..write(obj.startDate);
  }
}
