import 'package:custed2/core/util/time_point.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

extension StringX on String {
  TimePoint get tp => TimePoint.fromString(this);

  Uri get uri => Uri.parse(this);

  URLRequest get uq => URLRequest(url: this.uri);

  bool operator <(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s < num.parse(x) : s < x;
  }

  bool operator >(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s > num.parse(x) : s > x;
  }

  bool operator <=(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s <= num.parse(x) : s <= x;
  }

  bool operator >=(Object x) {
    final s = num.tryParse(this);
    if (s == null) return null;
    return x is String ? s >= num.parse(x) : s >= x;
  }
}
