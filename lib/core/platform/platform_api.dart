import 'dart:io';

abstract class PlatformApi<T> {
  const PlatformApi();

  T andriod() {
    return null;
  }

  T ios() {
    return null;
  }

  // 对应各种桌面平台
  T fuchsia() {
    return null;
  }

  T invoke() {
    if (Platform.isIOS) {
      return ios();
    }

    if (Platform.isAndroid) {
      return andriod();
    }

    return fuchsia();
  }
}
