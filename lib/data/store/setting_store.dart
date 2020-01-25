import 'package:custed2/core/store/presistent_store.dart';

class SettingStore with PresistentStore {
  @override
  final boxName = 'setting';

  StoreProperty<bool> get useScheduleAsHome =>
      property('useScheduleAsHome', defaultValue: false);

  StoreProperty<bool> get showInactiveLessons =>
      property('showInactiveLessons', defaultValue: true);
}
