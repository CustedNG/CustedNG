import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/service/custed_service.dart';
import 'package:flutter/widgets.dart';

class AppProvider extends ProviderBase {
  String _notification;
  Map _changeLog;
  BuildContext ctx;

  String get notification => _notification;
  Map get changeLog => _changeLog; 

  Future<void> loadLocalData() async {
    final notification = await CustedService().getNotify();
    final changeLog = await CustedService().getChangeLog();

    _notification = notification;
    _changeLog = changeLog;
    notifyListeners();
  }

  void setContext(c) {
    ctx = c;
  }
}
