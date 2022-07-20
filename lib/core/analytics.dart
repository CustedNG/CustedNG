import 'dart:async';
import 'dart:io';

import 'package:countly_flutter/countly_flutter.dart';
import 'package:countly_flutter/countly_config.dart' as cc;
import 'package:custed2/config/countly.dart';
import 'package:custed2/core/util/build_mode.dart';

class Analytics {
  static const _url = CountlyConfig.url;
  static const _key = CountlyConfig.key;

  static bool _enabled = false;

  static Future<void> init() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _enabled = true;
      final config = cc.CountlyConfig(_url, _key)
          .setLoggingEnabled(BuildMode.isDebug)
          .enableCrashReporting();
      await Countly.initWithConfig(config);
      await Countly.start();
      await Countly.giveAllConsent();
    } else {
      print('[COUNTLY] Unsupported platform ${Platform.operatingSystem}');
    }
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
