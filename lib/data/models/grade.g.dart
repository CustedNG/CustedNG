// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeAdapter extends TypeAdapter<Grade> {
  @override
  final int typeId = 5;

  @override
  Grade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grade()
      ..averageGradePoint = fields[0] as double
      ..creditEarned = fields[1] as double
      ..creditUnattained = fields[2] as double
      ..subjectCount = fields[3] as int
      ..subjectPassed = fields[4] as int
      ..subjectNotPassed = fields[5] as int
      ..resitCount = fields[6] as int
      ..retakeCount = fields[7] as int
      ..createdAt = fields[9] as DateTime
      ..versionHash = fields[10] as String
      ..terms = (fields[11] as List)?.cast<GradeTerm>();
  }

  @override
  void write(BinaryWriter writer, Grade obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.averageGradePoint)
      ..writeByte(1)
      ..write(obj.creditEarned)
      ..writeByte(2)
      ..write(obj.creditUnattained)
      ..writeByte(3)
      ..write(obj.subjectCount)
      ..writeByte(4)
      ..write(obj.subjectPassed)
      ..writeByte(5)
      ..write(obj.subjectNotPassed)
      ..writeByte(6)
      ..write(obj.resitCount)
      ..writeByte(7)
      ..write(obj.retakeCount)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.versionHash)
      ..writeByte(11)
      ..write(obj.terms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
