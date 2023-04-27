class TimePoint {
  int minutes;

  TimePoint(int hour, int minute) : minutes = hour * 60 + minute;

  TimePoint.minutes(this.minutes);

  TimePoint.fromString(String str) {
    final part = str.split(':');
    final hour = int.parse(part[0]);
    minutes = hour * 60 + int.parse(part[1]);
  }

  TimePoint.fromInt(int start) {
    TimePoint.fromString(sectionStartMap[int]);
  }

  TimePoint.fromDateTime(DateTime dateTime) {
    minutes = dateTime.hour * 60 + dateTime.minute;
  }

  int get hour => minutes ~/ 60;
  int get minute => minutes % 60;

  bool isBefore(DateTime dateTime) {
    return this.minutes < (dateTime.hour * 60 + dateTime.minute);
  }

  bool isAfter(DateTime dateTime) {
    return this.minutes > (dateTime.hour * 60 + dateTime.minute);
  }

  bool isBeforeOrSameAs(DateTime dateTime) {
    return this.minutes <= (dateTime.hour * 60 + dateTime.minute);
  }

  bool isAfterOrSameAs(DateTime dateTime) {
    return this.minutes >= (dateTime.hour * 60 + dateTime.minute);
  }

  bool isSame(DateTime dateTime) {
    return this.minutes == (dateTime.hour * 60 + dateTime.minute);
  }

  Duration get sinceDayStart {
    return Duration(minutes: minutes);
  }

  Duration substract(TimePoint other) =>
      Duration(minutes: minutes - other.minutes);

  @override
  String toString() {
    return '$hour:$minute';
  }
}

final sectionStartMap = {
  1: '8:00',
  2: '8:50',
  3: '10:05',
  4: '10:50',
  5: '13:30',
  6: '14:20',
  7: '15:35',
  8: '16:25',
  9: '18:00',
  10: '18:50',
  11: '19:45',
  12: '20:35',
};
