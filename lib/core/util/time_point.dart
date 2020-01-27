class TimePoint {
  TimePoint(hour, minute);

  TimePoint.fromString(String str) {
    final part = str.split(':');
    hour = int.parse(part[0]);
    minute = int.parse(part[1]);
  }

  int hour;
  int minute;

  bool isBefore(DateTime dateTime) {
    return (this.hour * 60 + this.minute) <
        (dateTime.hour * 60 + dateTime.minute);
  }

  @override
  String toString() {
    return '$hour:$minute';
  }
}
