// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_term.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeTermAdapter extends TypeAdapter<GradeTerm> {
  @override
  final int typeId = 7;

  @override
  GradeTerm read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeTerm()
      ..averageGradePoint = fields[0] as double
      ..creditTotal = fields[1] as double
      ..creditEarned = fields[2] as double
      ..subjectCount = fields[3] as int
      ..subjectPassed = fields[4] as int
      ..grades = (fields[6] as List)?.cast<GradeDetail>()
      ..termName = fields[7] as String
      ..averageGradePointNoElectiveCourse = fields[8] as double;
  }

  @override
  void write(BinaryWriter writer, GradeTerm obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.averageGradePoint)
      ..writeByte(1)
      ..write(obj.creditTotal)
      ..writeByte(2)
      ..write(obj.creditEarned)
      ..writeByte(3)
      ..write(obj.subjectCount)
      ..writeByte(4)
      ..write(obj.subjectPassed)
      ..writeByte(6)
      ..write(obj.grades)
      ..writeByte(7)
      ..write(obj.termName)
      ..writeByte(8)
      ..write(obj.averageGradePointNoElectiveCourse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeTermAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
