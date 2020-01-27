import 'package:countly_flutter/countly_flutter.dart';

class Analytics {
  static const _url = '';
  static const _key = '';

  static bool _enabled = false;

  static void init() async {
    if (_url.isEmpty || _key.isEmpty) {
      return;
    }

    _enabled = true;
    await Countly.init(_url, _key);
    await Countly.enableCrashReporting();
  }

  static set isDebug(bool value) {
    Countly.isDebug = value;
  }

  static void recordView(String view) {
    if (!_enabled) return;
    Countly.recordView(view);
  }
}
