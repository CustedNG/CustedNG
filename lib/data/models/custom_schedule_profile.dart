class CustomScheduleProfile {
  CustomScheduleProfile({this.name, this.studentNumber, this.uuid});

  String name;
  String studentNumber;
  String uuid;
  int lastUpdated;

  factory CustomScheduleProfile.fromPrimitiveMap(Map<String, dynamic> obj) {
    return CustomScheduleProfile()
      ..studentNumber = obj['studentNumber'] as String
      ..name = obj['name'] as String
      ..uuid = obj['uuid'] as String
      ..lastUpdated = obj['lastUpdated'] as int;
  }

  Map<String, dynamic> toPrimitiveMap() {
    return {
      'name': name,
      'studentNumber': studentNumber,
      'uuid': uuid,
      'lastUpdated': lastUpdated
    };
  }

  @override
  String toString() {
    return 'ExternalUserProfile{name: $name, studentNumber: $studentNumber, uuid: $uuid}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomScheduleProfile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          studentNumber == other.studentNumber &&
          uuid == other.uuid;

  @override
  int get hashCode => name.hashCode ^ studentNumber.hashCode ^ uuid.hashCode;
}
