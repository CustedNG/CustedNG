// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_term.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeTermAdapter extends TypeAdapter<GradeTerm> {
  @override
  final typeId = 7;

  @override
  GradeTerm read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GradeTerm()
      ..averageGradePoint = fields[0] as double
      ..creditTotal = fields[1] as double
      ..creditEarned = fields[2] as double
      ..subjectCount = fields[3] as int
      ..subjectPassed = fields[4] as int
      ..grades = (fields[6] as List)?.cast<GradeDetail>()
      ..termName = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, GradeTerm obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.termName);
  }
}
