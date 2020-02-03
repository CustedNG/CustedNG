import 'dart:async';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:custed2/core/extension/intx.dart';
import 'package:dio/dio.dart';

class Analytics {
  static const _url = '';
  static const _key = '';

  static bool _enabled = false;

  static Future<void> init() async {
    if (_url.isEmpty || _key.isEmpty) {
      return;
    }

    _enabled = true;
    await Countly.init(_url, _key);
    Countly.enableCrashReporting();
    Countly.giveAllConsent();
  }

  static set isDebug(bool value) {
    Countly.isDebug = value;
    Countly.setLoggingEnabled(value);
  }

  static void recordView(String view) {
    if (!_enabled) return;
    Countly.recordView(view);
  }

  static void recordException(Object exception, [bool fatal = false]) {
    if (!_enabled) return;
    Countly.logException(exception.toString(), !fatal, null);
  }
}
