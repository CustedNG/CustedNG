import 'package:custed2/data/models/jw_schedule_section.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jw_schedule_for_day.g.dart';

// ignore_for_file: non_constant_identifier_names

@JsonSerializable()
class JwScheduleForDay {
  JwScheduleForDay();

  List<JwScheduleSection> MN__TimePieces;
  List<JwScheduleSection> AM__TimePieces;
  List<JwScheduleSection> AF__TimePieces;
  List<JwScheduleSection> PM__TimePieces;
  List<JwScheduleSection> EV__TimePieces;

  String EnglishTitle;
  String FullTitle;
  String SimpleEnglish;
  String SimpleTitle;
  int WIndex;

  factory JwScheduleForDay.fromJson(Map<String, dynamic> json) =>
      _$JwScheduleForDayFromJson(json);

  Map<String, dynamic> toJson() => _$JwScheduleForDayToJson(this);

  List<JwScheduleSection> allSections() => [
        ...MN__TimePieces,
        ...AM__TimePieces,
        ...AF__TimePieces,
        ...PM__TimePieces,
        ...EV__TimePieces,
      ];

  @override
  String toString() {
    return '$FullTitle($WIndex)\n' +
        allSections().map((s) => s.toString()).join('\n');
  }
}
