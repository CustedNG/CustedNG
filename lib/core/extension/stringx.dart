import 'package:custed2/core/util/time_point.dart';

extension StringX on String {
  Uri toUri() => Uri.parse(this);

  TimePoint get tp => TimePoint.fromString(this);
}
