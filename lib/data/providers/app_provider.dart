import 'dart:io';

import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/core/update.dart';
import 'package:custed2/core/util/utils.dart';
import 'package:custed2/data/models/custed_config.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:flutter/material.dart';

class AppProvider extends ProviderBase {
  BuildContext ctx;
  CustedConfig _config;
  int newest = BuildData.build;
  CustedConfig get config => _config;

  Future<void> loadLocalData() async {
    final service = CustedService();

    _config = await service.getConfig();
    notifyListeners();

    updateCheck(ctx);
  }

  bool get useKBPro {
    if (config == null) return false;
    final cs = config.useKbpro;
    final ver = BuildData.build;
    for (final c in cs) {
      if (c.contains('-')) {
        final range = c.split('-');
        final start = int.parse(range[0]);
        final end = int.parse(range[1]);
        if (ver >= start && ver <= end) {
          return true;
        }
      } else {
        if (ver == int.parse(c)) {
          return true;
        }
      }
    }
    return false;
  }

  bool get showExam {
    if (config == null) return true;
    return config.haveExam;
  }

  bool get showRealUI {
    if (Platform.isAndroid) return true;
    if (config == null) return true;
    final fakeBuilds = config.notShowRealUi;
    return !fakeBuilds.contains(BuildData.build);
  }

  String get notification {
    if (config == null) return null;
    final ns = config.notify;
    final vers = ns.map((e) => e.version).toList();
    final b = BuildData.build;
    vers.removeWhere((e) => e < b);
    vers.sort();
    if (vers.isNotEmpty) {
      return ns.firstWhere((e) => e.version == vers.first).content;
    }
    if (ns.isNotEmpty) {
      return ns.first.content;
    }
    return '暂时无法获取通知。发布于：现在';
  }

  CustedConfigSchoolCalendar get cal {
    if (config == null) return null;
    final cals = config.schoolCalendar;
    if (cals == null) return null;
    for (final cal in cals) {
      if (cal.term == getTerm) {
        return cal;
      }
    }
    return null;
  }

  CustedConfigBanner get banner => config?.banner;

  void setContext(c) {
    ctx = c;
  }
}
