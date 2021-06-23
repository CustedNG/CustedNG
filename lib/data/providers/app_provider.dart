import 'dart:io';

import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/core/utils.dart';
import 'package:custed2/res/build_data.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppProvider extends ProviderBase {
  String _notification;
  Map _changeLog;
  bool _showRealUI = true;
  bool _useKBPro = false;
  String _testerNameList;
  BuildContext ctx;
  int build = BuildData.build;

  String get notification => _notification;
  Map get changeLog => _changeLog;
  bool get showRealUI => _showRealUI;
  String get testerNameList => _testerNameList;
  bool get useKBPro => _useKBPro;

  Future<void> loadLocalData() async {
    final service = CustedService();
    _notification = await service.getNotify();
    _changeLog = await service.getChangeLog();
    _showRealUI = await service.showRealCustedUI() || Platform.isAndroid;
    _testerNameList = await service.getTesterNameList();
    _useKBPro = await service.useKBPro();

    notifyListeners();

    showImportantNotify();
  }

  void showImportantNotify() {
    if (ctx == null) return;
    if (notification.startsWith('！')) {
      showRoundDialog(
        ctx, 
        '重要提示', 
        Text(notification.substring(1)), 
        [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), 
            child: Text('关闭')
          )
        ]
      );
    }
  }

  void setContext(c) {
    ctx = c;
  }
}
