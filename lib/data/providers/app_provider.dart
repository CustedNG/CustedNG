import 'package:custed2/core/provider/provider_base.dart';
import 'package:custed2/service/custed_service.dart';

class AppProvider extends ProviderBase {
  String _notification;
  Map _changeLog;

  String get notification => _notification;
  Map get changeLog => _changeLog; 

  Future<void> loadLocalData() async {
    final notification = await CustedService().getNotify();
    final changeLog = await CustedService().getChangeLog();

    _notification = notification;
    _changeLog = changeLog;
    notifyListeners();
  }

  void setTab(int index, {bool refresh = true}) {
    if (refresh) notifyListeners();
  }
}
