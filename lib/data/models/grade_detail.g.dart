// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeDetailAdapter extends TypeAdapter<GradeDetail> {
  @override
  final int typeId = 6;

  @override
  GradeDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeDetail()
      ..year = fields[0] as String
      ..testStatus = fields[1] as String
      ..lessonType = fields[2] as String
      ..schoolHour = fields[3] as double
      ..credit = fields[4] as double
      ..mark = fields[5] as double
      ..rawMark = fields[6] as String
      ..lessonName = fields[7] as String
      ..testType = fields[8] as String
      ..lessonCategory = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, GradeDetail obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.testStatus)
      ..writeByte(2)
      ..write(obj.lessonType)
      ..writeByte(3)
      ..write(obj.schoolHour)
      ..writeByte(4)
      ..write(obj.credit)
      ..writeByte(5)
      ..write(obj.mark)
      ..writeByte(6)
      ..write(obj.rawMark)
      ..writeByte(7)
      ..write(obj.lessonName)
      ..writeByte(8)
      ..write(obj.testType)
      ..writeByte(9)
      ..write(obj.lessonCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
