import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/data/store/setting_store.dart';
import 'package:custed2/locator.dart';
import 'package:custed2/service/custed_service.dart';

class AppProvider extends ProviderBase {
  int _tabIndex = homeTab;
  String _notification;

  int get tabIndex => _tabIndex;
  String get notification => _notification;

  static const homeTab = 0;
  static const navTab = 1;
  static const gradeTab = 2;
  static const scheduleTab = 3;
  static const userTab = 4;

  Future<void> loadLocalData() async {
    final setting = locator<SettingStore>();
    final useScheduleAsHome = setting.useScheduleAsHome.fetch();
    final notification = await CustedService().getNotify();

    if (useScheduleAsHome == true) {
      print('useScheduleAsHome: $useScheduleAsHome');
      _tabIndex = scheduleTab;
    }
    _notification = notification;
    notifyListeners();
  }

  void setTab(int index, {bool refresh = true}) {
    _tabIndex = index;
    if (refresh) notifyListeners();
  }
}
