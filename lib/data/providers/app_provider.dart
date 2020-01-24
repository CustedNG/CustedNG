import 'dart:math' as math;

import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';

class AppProvider extends ProviderBase {
  int _tabIndex = homeTab;
  int get tabIndex => _tabIndex;

  static const homeTab = 0;
  static const gradeTab = 1;
  static const scheduleTab = 2;
  static const userTab = 3;

  void loadLocalData() {
    final setting = locator<SettingStore>();
    final useScheduleAsHome = setting.useScheduleAsHome.fetch();

    if (useScheduleAsHome == true) {
      print('useScheduleAsHome: $useScheduleAsHome');
      _tabIndex = scheduleTab;
      notifyListeners();
    }
  }

  void setTab(int index) {
    _tabIndex = index;
    notifyListeners();
  }
}
