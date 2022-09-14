import 'package:custed2/core/store/persistent_store.dart';
import 'package:flutter/material.dart';

class SettingStore with PersistentStore {
  @override
  final boxName = 'setting';

  StoreProperty<bool> get useScheduleAsHome =>
      property('useScheduleAsHome', defaultValue: false);

  StoreProperty<bool> get showFestivalAndHoliday =>
      property('showFestivalAndHoliday', defaultValue: true);

  StoreProperty<bool> get showInactiveLessons =>
      property('showInactiveLessons', defaultValue: true);

  StoreProperty<bool> get autoUpdateSchedule =>
      property('autoUpdateSchedule', defaultValue: true);

  StoreProperty<bool> get autoUpdateWeather =>
      property('autoUpdateWeather', defaultValue: true);

  StoreProperty<bool> get dontCountElectiveCourseGrade =>
      property('dontCountElectiveCourseGrade', defaultValue: false);

  StoreProperty<bool> get agreeToShowExam =>
      property('agreeToShowExam', defaultValue: false);

  StoreProperty<bool> get gradeSafeMode =>
      property('gradeSafeMode', defaultValue: false);

  StoreProperty<int> get darkMode => property('darkMode', defaultValue: 0);

  StoreProperty<int> get ignoreUpdate => property('ignoreUpdate');

  StoreProperty<bool> get saveWiFiPassword =>
      property('saveCampusWiFi', defaultValue: true);

  StoreProperty<bool> get pushNotification =>
      property('pushNotification', defaultValue: false);

  StoreProperty<int> get scheduleTheme =>
      property('scheduleTheme', defaultValue: 1);

  StoreProperty<int> get appPrimaryColor =>
      property('appPrimaryColor', defaultValue: Colors.purpleAccent.value);

  StoreProperty<bool> get scheduleHideWeekend =>
      property('scheduleHideWeekend', defaultValue: false);

  StoreProperty<bool> get scheduleUseGradient =>
      property('scheduleUseGradient', defaultValue: true);

  /// 是否同意了用户协议，因为没同意用户协议就不会进入app，
  /// 所以可以用作判断是否进行过初始化设置
  StoreProperty<bool> get userAgreement =>
      property('userAgreement', defaultValue: false);

  /// 是否是研究生
  StoreProperty<bool> get isGraduate =>
      property('isGraduate', defaultValue: false);
}
