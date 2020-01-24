import 'package:custed2/core/store/presistent_store.dart';

class SettingStore with PresistentStore {
  @override
  final boxName = 'setting';

  Property<bool> get useScheduleAsHome =>
      property('useScheduleAsHome', defaultValue: false);
}
